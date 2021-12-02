from dataclasses import dataclass


@dataclass
class ConnectionDetails:
    """A simple data structure for holding database connection information."""
    host: str = None
    database: str = None
    region: str = None
    user: str = None
    port: str = None
    profile_name: str = None
