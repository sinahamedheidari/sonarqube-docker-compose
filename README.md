# sonarqube-docker-compose

### [SonarQube®](https://www.sonarqube.org/) is an automatic code review tool to detect bugs, vulnerabilities, and code smells in your code. It can integrate with your existing workflow to enable continuous code inspection across your project branches and pull requests.


You can build and deploy your Sonarqube instance on development or production environment. The benefit of this image is that you can have local volumes as well as docker volumes. The Official image gets `AccessDenied` error on using local volumes. To overcome that you have to use Sonarqube Latest version (or at least 9.0) but it also needs Docker version at least 20. By using this image you can easily build and run Sonarqube on older version of Docker with local volumes without any issue.

## How to build
Clone the repo and then build the image:
```
git clone https://github.com/sinahamedheidari/sonarqube-docker-compose
cd sonarqube-docker-compose
docker build -t sonarqube:7.9.6 .
docker-compose up -d
```
## Upgrade
You can also upgrade the sonarqube by changing the value of `SONAR_VERSION` environment variable in Dockerfile.