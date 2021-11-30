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

import MySQLdb
import MySQLdb.cursors
import psycopg2
import psycopg2.extras


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
        try:
            self.conn = psycopg2.connect(host='localhost', database=self.dbname, user=self.user, password=self.password)
            return DBCursor(self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))
        except Exception as e:
                raise self.DBConnectionError(f'Database connection failed due to {e}')

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class LocalMySqlConnection(DBConnection):
    """A connection to the local MySQL instance."""

    def __init__(self, dbname: str = 'lura_cert', user: str = 'root'):
        self.dbname = dbname
        self.user = user

    def __enter__(self):
        try:
            self.conn = MySQLdb.connect(host='127.0.0.1', database=self.dbname, user=self.user, cursorclass=MySQLdb.cursors.DictCursor)
            return DBCursor(self.conn.cursor())
        except Exception as e:
            raise self.DBConnectionError(f'Database connection failed due to {e}')

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()
