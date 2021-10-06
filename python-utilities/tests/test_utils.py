from typing import List

from lib.db_connections import LocalEDWConnection, DBDictCursor


class MockLocalEDWConnection(LocalEDWConnection):

    def __init__(self, query_results: List[dict]):
        super().__init__()
        self.query_results = query_results

    def __enter__(self):
        return MockDBCursor(self.query_results)

    def __exit__(self, exc_type, exc_val, exc_tb):
        pass


class MockDBCursor(DBDictCursor):

    def __init__(self, query_results: List[dict]):
        super().__init__(None)
        self.query_results = query_results

    def select(self, sql: str) -> List[dict]:
        return self.query_results
