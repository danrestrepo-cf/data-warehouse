from dataclasses import dataclass


@dataclass
class TablePath:
    database: str
    schema: str
    table: str
