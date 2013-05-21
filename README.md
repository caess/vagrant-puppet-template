This is my template for Vagrant-based projects with Puppet.  This is based on Patrick Debois' blog post [Test Driven Infrastructure with Vagrant, Puppet, and Guard](http://www.jedi.be/blog/2011/12/13/testdriven-infrastructure-with-vagrant-puppet-guard/) and the associated [github repo](http://github.com/jedi4ever/vagrant-guard-demo).

### To use
#### Setting up the repository
1.  Create an empty repository:

        git init
        touch .gitignore
        git add .gitignore
        git commit -m "Initial commit."
2. Create a remote branch for the template:

        git remote add template/master https://github.com/caess/vagrant-puppet-template.git
3. Fetch the content from this repo:

        git fetch template
4. Merge in the template:

        git merge --squash template/master
5. Commit with the desired commit message.

#### Incorporating template updates
1. Update the remote branch:

        git fetch template
2. Merge in the template:

        git merge --squash template/master
3. Commit with the desired commit message. 