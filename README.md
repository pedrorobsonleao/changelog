# changelog

Build a simple changelog markdown report to your github repository.

## how to use

```bash
$ changelog.sh --help
Use: changelog <options>

     options
     -i, --issue-base-url  : issue tracker base url
     -t, --start-tag       : initial tag
     -h, --help            : this message
```

### without parameter

Generate a full changelog to your git repository.

Attention, the [changelog](./changelog.sh) have your tags with the base to make your changelog.

### help paremeter

Show the list of use modes.

### start-tag parameter

Create your changelog started after the `TAG` in the `--start-tag` parameter.

### issue-base-url

In this parameter you input your jira bug tracker url to identify issue number partner and make the link in your markdown file.
