from dataclasses import dataclass


@dataclass
class ConnectionDetails:
    host: str = None
    database: str = None
    region: str = None
    user: str = None
    port: str = None
    profile_name: str = None
