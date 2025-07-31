
# Enterprise Network
Enterprise network consists of various role-assigned servers
which include:
- web server
	- used to host websites
- mail server
	- handles and delivers e-mail over a network usually over the internet.
	- SMTP/POP3
- database server
	- Used to store and manage databases
- bastion-host (jump- server)
	- special purpose computer on a network specifically designed and configured to withstand attacks.
- Automation server
	- crucial aspect of software development workflow
	- helps automate parts of software developemt related to building, testing, and deploying facilitaing continues integration and continuos delivery (CI/CD).
	- Examples:
		- Jenkins Server
		- Bamboo

### Active Directory
A directory which does the follows:
- manages the resources of organizations like (users, computers, shares etc)
- provides access rules that govern the relationships between these resources.
- stores information about objects on the network and makes it available to users and admins.
- Provides centralized management of all the organization virtual assets.

#### Forests/Domain
- Forest is a single instance of active directory.
	- It is a basically a collection of domain controllers that trust one another.
- Domains can be thought as containers within the scope of a forest.
- Organizations Units (OU's) are logical grouping of users, computers and other resources
- Groupts
	- collection of users or other groups
	- privileged, non-privileged.

#### Active Directory Objects
The physical entities that make up an organized network
- Domain Users:
	- User account that are allowed to authenticate to machines/servers in the domain
- Domain Groups (Global Groups):
	- It can be use to assign permissions to access resources in any domain
- Domain computers:
	- Machines that are connected to a domain and hence become a member of a domain.
- Domain controller: 
	- Server located centrally that responds to security authentication requests and manages various resources like computers, users, groups etc.
- Group Policy Objects (GPOs):
	- Collection of policies that are applied to a set of user, domain, domain object etc.
- Ticket Granting Ticket:
	- Ticket used specifically for authentication
- Ticket Granting Service:
	- Ticket used specifically for authorization

#### kerberos Authentication:
- in AD all queries and authentication process is done through tickets. Hence, no passwords travel through the network.
- a ticket is a form of authentication and authorization token and can be categorized as follows: 
	-  Ticket Granting Ticket:
		- Ticket used specifically for authentication
	- Ticket Granting Service:
		- Ticket used specifically for authozisation

The tickets are stored in memory and can be extracted for abusing purposes as these tickets represent user credentials.
