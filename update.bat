REM https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork	
set GIT_SSH=c:\Program Files\TortoiseGit\bin\TortoisePlink.exe
git remote -v
git remote add upstream git@github.com:xmldom/xmldom.git
git remote -v
git fetch upstream
git checkout --track origin/master