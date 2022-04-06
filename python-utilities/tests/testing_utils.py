"""A collection of utility classes/functions to be used in the unit test suite."""

from typing import List

from lib.db_connections.connections import DBConnection, DBCursor


class MockDBConnection(DBConnection):
    """A database connection that will always return the same results no matter the query."""

    def __init__(self, query_results: List[dict]):
        super().__init__()
        self.query_results = query_results

    def __enter__(self):
        return MockDBCursor(self.query_results)

    def __exit__(self, exc_type, exc_val, exc_tb):
        pass


class MockDBCursor(DBCursor):
    """A query cursor that will always return the same results no matter the query."""

    def __init__(self, query_results: List[dict]):
        super().__init__(None)
        self.query_results = query_results

    def execute_and_fetch_all_results(self, sql: str) -> List[dict]:
        return self.query_results
