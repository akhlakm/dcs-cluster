Set up an on-premise Distributed Computing and Storage cluster of *High Availability* using Ansible, Docker, CentOS, Nomad, and PySpark.

### USAGE

Clone the repository to a workstation not a part of the cluster. Initialize the current working environment by running the `setup.sh` script. It will check your
local workstation and install necessary packages including Ansible and ssh keys.

```sh
./setup.sh
```

Update the Ansible `hosts` file and `host_vars/` directory contents with correct cluster node names
and variables. Next, run the ansible playbook.

```sh
ansible-playbook playbook.yml
```

# Architecture

## Points of Cluster Failure
1. Assuming a single type of OS/software/environment
2. Failure of communication between the nodes
3. Failure of the wireless network
4. Change of the wireless network
5. Bugs in newer updates/versions

## Pull vs. Push Administration

- Pull-based administration might be useful to make changes to many nodes and auto-update the systems depending on external changes (e.g. network). It also requires a resilient/external source of truth.

- Push is useful for a small number of nodes, and manual updates. When the development process is done, usually we are willing to manually update the systems. The controller is the source of truth, no external/resilient server is required.

- Pull updates must be tested in a virtual environment before deployment. Push updates can be tested directly in an agile way as long as it does not invalidate the existing services.

- Push updates are prone to more errors since points of failure are usually not considered.

## Addressing the Points of Failure
1. Adopt the push-based administration, since the cluster development needs to be agile.

2. Check and validate the ground truths including the type of OS, network communication, network addresses, software version, type and presence of hardware, etc before making any changes.

3. In the event of failure of communication, making changes need to be quick and with a run of the setup script. For this to work, there should be a single point of entry in the admin scripts, i.e. the `playbook.yml` file.

4. To understand what changes need to be made, detailed logging and debugging messages would be useful.

## Choice of Software

- **Ansible** to implement the cluster Infrastructure as Code (IaC).
- **CentOS 8** for stability.
- **Docker** for virtual environment and containerization - easier testing and deployment.
- **Nomad** for management of resources without the complexities of Kubernetes while avoiding a single point of failure.
- **MooseFS** as a Data Lake for distributed storage, automated data replication, data backup, and load balancing.
- **PostgreSQL** for Data Warehousing.
- **PySpark** for data pipelining and analysis.

