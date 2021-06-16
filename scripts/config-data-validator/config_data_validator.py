"""
Config data validator: a script to check the contents of each config.mdi schema table against a specific set
of validation rules
https://app.asana.com/0/0/1200343485858665
"""

import psycopg2
import psycopg2.extras
import pandas
from typing import List

def main():
    raw_edw_config_data = read_raw_config_data_from_edw()

def read_raw_config_data_from_edw() -> List[dict]:
    with EDW() as cursor:
        return cursor.select_as_list_of_dicts("""
        SELECT dwid
            , name
            , description
        FROM mdi.config
        """)

class EDW:
    """
    A connection to EDW. When used as a context manager, returns an EDWCursor
    instance.
    """

    def __init__(self, host: str = 'localhost', dbname: str = 'config', user: str = 'postgres', password: str = 'testonly'):
        self.host = host
        self.dbname = dbname
        self.user = user
        self.password = password

    def __enter__(self):
        self.conn = psycopg2.connect(host=self.host, database=self.dbname, user=self.user, password=self.password)
        return EDWCursor(self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class EDWCursor:
    """
    A simple wrapper around psycopg2's cursor with method(s) added to facilitate
    more expressive code
    """

    def __init__(self, cursor):
        self.cursor = cursor

    def select_as_list_of_dicts(self, sql: str) -> List[dict]:
        self.cursor.execute(sql)
        return self.cursor.fetchall()


if __name__ == '__main__':
    main()