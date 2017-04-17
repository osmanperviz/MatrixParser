# Task

This task consists of three services/interactor, one interactor/organizer and tree parse adapter class.

# Organizer

Iterator/organizer(MatrixParser) is responsible for a chain call for three services(`FetchAndUnzipService, ClassificationService, DispatchService`)

# FetchAndUnzipService

Responsible for fetching and unziping files from remote system.

# ClassificationService

Responsible for calling right parse adapter,

# DispatchService

Responsible for sending final results to the remote system

# Sentinels parse adapter

Responsible for parsing sentinels data

# Loophole parse adapter

Responsible for parsing loopholes data

# Sniffer parse adapter

Responsible for parsing sniffer data
