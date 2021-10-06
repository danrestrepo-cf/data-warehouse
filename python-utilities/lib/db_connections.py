import os
from typing import List

import mysql.connector
import psycopg2
import psycopg2.extras
import boto3


class LocalEDWConnection:
    """
    A connection to the local EDW instance. When used as a context manager, returns a DBDictCursor
    """

    def __init__(self, host: str = 'localhost', dbname: str = 'config', user: str = 'postgres', password: str = 'testonly'):
        self.host = host
        self.dbname = dbname
        self.user = user
        self.password = password

    def __enter__(self):
        self.conn = psycopg2.connect(host=self.host, database=self.dbname, user=self.user, password=self.password)
        return DBDictCursor(self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class OctaneDBConnection:
    """
    A connection to an Octane database. When used as a context manager, returns a DBCursor
    instance.
    """

    def __init__(self, host: str, dbname: str, region: str, user: str, port: str, profile_name: str, ssl_ca_filepath: str):
        self.host = host
        self.dbname = dbname
        self.region = region
        self.user = user
        self.port = port
        self.profile_name = profile_name
        self.ssl_ca_filepath = ssl_ca_filepath

        os.environ['LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN'] = '1'

        session = boto3.Session(profile_name=self.profile_name)
        client = session.client('rds')

        self.token = client.generate_db_auth_token(DBHostname=self.host, Port=self.port, DBUsername=self.user, Region=self.region)

    def __enter__(self):

        try:
            self.conn = mysql.connector.connect(host=self.host, user=self.user, passwd=self.token, port=self.port, database=self.dbname,
                                                ssl_ca=self.ssl_ca_filepath)
            return DBDictCursor(self.conn.cursor(dictionary=True))
        except Exception as e:
            print("Database connection failed due to {}".format(e))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class DBDictCursor:
    """
    A simple wrapper around a database cursor with method(s) added to facilitate
    more expressive code
    """

    def __init__(self, cursor):
        self.cursor = cursor

    def select(self, sql: str) -> List[dict]:
        self.cursor.execute(sql)
        return self.cursor.fetchall()
