# Knife EC2 SSH config

Knife plugin to update ssh client config with ec2 instance information

## Installation

If you're using bundler, simply add Chef and Knife EC2 to your Gemfile:

```
gem 'chef'
gem 'knife-ec2-ssh-config'
```

And then execute:

```
$ bundle
```

If you are not using bundler, you can install the gem manually. Be sure you are running Chef 0.10.10 or higher, as earlier versions do not support plugins.

```
$ gem install chef
$ gem installknife-ec2-ssh-config
```

Depending on your system's configuration, you may need to run this command with root privileges.

## Configuration

In order to communicate with the Amazon's EC2 API you will have to tell Knife about your AWS Access Key and Secret Access Key. The easiest way to accomplish this is to create some entries in your `knife.rb` file:

```ruby
knife[:aws_access_key_id] = "Your AWS Access Key ID"
knife[:aws_secret_access_key] = "Your AWS Secret Access Key"
```

If your `knife.rb` file will be checked into a SCM system (ie readable by others) you may want to read the values from environment variables:

```ruby
knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
```

You also have the option of passing your AWS API Key/Secret into the individual knife subcommands using the `-A` (or `--aws-access-key-id`) `-K` (or `--aws-secret-access-key`) command options

If you are working with Amazon's command line tools, there is a good chance you already have a file with these keys somewhere in this format:

    AWSAccessKeyId=Your AWS Access Key ID
    AWSSecretKey=Your AWS Secret Access Key

In this case, you can point the <tt>aws_credential_file</tt> option to this file in your <tt>knife.rb</tt> file, like so:
```
knife[:aws_credential_file] = "/path/to/credentials/file/in/above/format"
```

## Usage

To update your ssh config, simply run:

```
$ knife ec2 ssh_config generate
```

The above will create a backup of your```~/.ssh/config``` and make the updates.  You can pass ssh user name by passing `-x` or `--ssh-user` flags. This config can also be set in your `knife.rb`

```ruby
knife[:ssh_user] = 'ubuntu'
```

You can also include identity file by passing `--identity-file` or `-i` flag, for eg:

```
$ knife ec2 ssh_config generate -i .chef/ssh-key.pem
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
