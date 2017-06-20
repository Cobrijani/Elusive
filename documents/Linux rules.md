# Linux log rules

This document contain alerts that are specified to occur on certain condition.

1. If in n timeframe FAILED PASSWORD x times from y IP ADDRESS.
3. If in n timeframe INVALID x times from y IP ADDRESS
4. If x COMMAND executed by y USER
5. If ERROR occurs when executing commands.
6. If new user registered with GID = 150 (group id for python) with shell != ( /sbin/nologin or /bin/false )