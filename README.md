This is my template for Vagrant-based projects with Puppet.  This is based on Patrick Debois' blog post [Test Driven Infrastructure with Vagrant, Puppet, and Guard](http://www.jedi.be/blog/2011/12/13/testdriven-infrastructure-with-vagrant-puppet-guard/) and the associated [github repo](http://github.com/jedi4ever/vagrant-guard-demo).

### To use
#### Setting up the repository
1.  Create a new repository:

        git init
        touch .gitignore
        git add .gitignore
        git commit -m "Initial commit."
2. Create a remote branch for the template:

        git remote add template https://github.com/caess/vagrant-puppet-template.git
3. Fetch the content from this repo:

        git fetch template
4. Create a tracking branch:

        git checkout --track -b template template/master
5. Go back to the master branch:

        git checkout master
6. Merge in the template:

        git merge --squash template
7. Commit with the desired commit message.

#### Incorporating template updates
(Note that this process is still under review.)

1. Update the remote branch:

        git fetch template
2. Check out the template branch:

        git checkout template
3. Update the branch:

        git pull
4. Using the output from git pull, generate a patch:

        git format-patch oldrev..newrev
5. Check out the master branch:

        git checkout master
6. Apply the patches:

        git apply <patch1> <patch2> ...
7. Add the changed files.  Commit with the desired commit message.