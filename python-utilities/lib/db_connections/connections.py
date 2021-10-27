"""A class hierarchy defining various ways of connecting to Mortgage Technology databases.

DBConnection is the base of the hierarchy, and should be used in all type hints related
to connection objects. The three instantiatable "leaves" of the hierarchy are:
- LocalPostgresConnection: used to connect to the local EDW database
- AWSPostgresConnection: used to connect to any non-local EDW databases
- AWSMySQLConnection: used to connect to any Octane databases

While these classes *can* be individually instantiated, the preferred method
of created database connection objects is to utilize the DBConnectionFactory
class instead.
"""

from typing import List
from abc import ABC, abstractmethod

import mysql.connector
import psycopg2
import psycopg2.extras
import boto3

from lib.db_connections.connection_details import ConnectionDetails


class DBConnection(ABC):
    """An abstract base class defining a database connection that can be used as a context manager"""

    @abstractmethod
    def __enter__(self) -> 'DBCursor':
        pass

    @abstractmethod
    def __exit__(self, exc_type, exc_val, exc_tb):
        pass

    class DBConnectionError(Exception):
        pass


class DBCursor:
    """A simple wrapper around a database cursor with method(s) added to facilitate more expressive code"""

    def __init__(self, cursor):
        self.cursor = cursor

    def execute_and_fetch_all_results(self, sql: str) -> List[dict]:
        self.cursor.execute(sql)
        return self.cursor.fetchall()


class LocalPostgresConnection(DBConnection):
    """A connection to the local PostgreSQL instance. When used as a context manager, returns a DBCursor"""

    def __init__(self, dbname: str = 'config', user: str = 'postgres', password: str = 'testonly'):
        self.dbname = dbname
        self.user = user
        self.password = password

    def __enter__(self):
        self.conn = psycopg2.connect(host='localhost', database=self.dbname, user=self.user, password=self.password)
        return DBCursor(self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class AWSDBConnection(DBConnection):
    """An abstract class defining a connection to a database hosted on AWS."""

    def __init__(self, connection_details: ConnectionDetails, ssl_ca_filepath: str):
        self._connection_details = connection_details
        self._ssl_ca_filepath = ssl_ca_filepath

        session = boto3.Session(profile_name=self._connection_details.profile_name)
        client = session.client('rds')

        self._token = client.generate_db_auth_token(
            DBHostname=self._connection_details.host,
            Port=self._connection_details.port,
            DBUsername=self._connection_details.user,
            Region=self._connection_details.region
        )

    @abstractmethod
    def establish_connection(self):
        pass

    @abstractmethod
    def create_cursor(self) -> DBCursor:
        pass

    def __enter__(self) -> DBCursor:

        try:
            self._conn = self.establish_connection()
            return self.create_cursor()
        except Exception as e:
            raise self.DBConnectionError(f'Database connection failed due to {e}')

    def __exit__(self, exc_type, exc_val, exc_tb):
        self._conn.commit()
        self._conn.close()


class AWSPostgresConnection(AWSDBConnection):
    """A connection to a PostgreSQL database hosted on AWS. When used as a context manager, returns a DBCursor instance."""

    def establish_connection(self):
        return psycopg2.connect(
            host=self._connection_details.host,
            port=self._connection_details.port,
            database=self._connection_details.database,
            user=self._connection_details.user,
            password=self._token,
            sslmode='prefer',
            sslrootcert=self._ssl_ca_filepath
        )

    def create_cursor(self) -> DBCursor:
        return DBCursor(self._conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))


class AWSMySQLConnection(AWSDBConnection):
    """A connection to a MySQL database hosted on AWS. When used as a context manager, returns a DBCursor instance."""

    def establish_connection(self):
        return mysql.connector.connect(
            host=self._connection_details.host,
            user=self._connection_details.user,
            passwd=self._token,
            port=self._connection_details.port,
            database=self._connection_details.database,
            ssl_ca=self._ssl_ca_filepath
        )

    def create_cursor(self) -> DBCursor:
        return DBCursor(self._conn.cursor(dictionary=True))
