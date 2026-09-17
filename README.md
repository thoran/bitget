# bitget

## Description

Access the Bitget API with Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitget.rb'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install bitget.rb
```

## Usage

### Setup

```ruby
bitget_client = Bitget::Client.new(
  api_key: 'api_key0',
  api_secret: 'api_secret0',
  api_passphrase: 'api_passphrase0'
)
```

### Configuration

Settings may be declared once, and every client built afterwards reads them as its defaults.

```ruby
Bitget.configure do |config|
  config.api_key = 'api_key0'
  config.api_secret = 'api_secret0'
  config.api_passphrase = 'api_passphrase0'
end

bitget_client = Bitget::Client.new
```

The settings are `api_key`, `api_secret`, `api_passphrase`, `debug` and `logger`.

Any of them may still be given per client, which wins over the configured value. The
credentials are named arguments; the rest go under `options`.

```ruby
bitget_client = Bitget::Client.new(
  api_key: 'api_key1',
  options: {logger: Logger.new('bitget.log', 'daily')}
)
```

### Logging

A client logs when it has somewhere to log to, and not at all when it does not. Hand it any
object answering to `#info` and `#error`; the standard library's `Logger` will do.

```ruby
require 'logger'

Bitget.configure do |config|
  config.logger = Logger.new($stdout)
end
```

`Logger` rotates by itself, so a daily log file wants no more than its second argument. It
will not create the directory, so make that first.

```ruby
require 'fileutils'
require 'logger'

log_file_path = File.expand_path(File.join(%w{~ log bitget log.txt}))
FileUtils.mkdir_p(File.dirname(log_file_path))

Bitget.configure do |config|
  config.logger = Logger.new(log_file_path, 'daily')
end
```

Before 0.6.0 the client chose the path, created the directory and rotated the file itself. It
no longer does any of that: what is logged is the client's business and where it goes is
yours, which is what lets a StringIO logger in a test, or a levelled one, or something which
is not a Logger at all, work as well as the above.

### Retrieve Info on All the Coins Traded

```ruby
bitget_client.spot_public_coins
# =>
#  {
#    "code" => "00000",
#    "msg" => "success",
#    "requestTime" => 1743252600562,
#    "data" => [
#      {
#        "coinId" => "1460",
#        "coin" => "U2U",
#        "transfer" => "false",
#        "chains" => [
#          {
#            "chain" => "UnicornUltraSolaris",
#            ...
#          }
#        ]
#      },
#      ...
#      {...}
#    ]
#    "areaCoin" => "no"
#  }
```

### Retrieve Info for One of the Coins Traded

```ruby
bitget_client.spot_public_coins(coin: 'BTC')
# =>
#  {
#    "code" => "00000",
#    "msg" => "success",
#    "requestTime" => 1743252619082,
#    "data" => [
#      {
#        "coinId" => "1",
#        "coin" => "BTC",
#        "transfer" => "true",
#        "chains" => [
#          {
#            "chain" => "BTC",
#            "needTag" => "false",
#            "withdrawable" => "true",
#            "rechargeable" => "true",
#            "withdrawFee" => "0.00005",
#            "extraWithdrawFee" => "0",
#            "depositConfirm" => "1",
#            "withdrawConfirm" => "1",
#            "minDepositAmount" => "0.00001",
#            "minWithdrawAmount" => "0.0005",
#            "browserUrl" => "https://www.blockchain.com/explorer/transactions/btc/",
#            "contractAddress" => nil,
#            "withdrawStep" => "0",
#            "withdrawMinScale" => "8",
#            "congestion" => "normal"
#          },
#          ...
#          {...}
#        ]
#      }
#    ]
#    "areaCoin" => "no"
#  }
```

### Get Account Information

```ruby
bitget_client.spot_account_info
```

### Get Account Assets

```ruby
bitget_client.spot_account_assets
```

```ruby
bitget_client.spot_account_assets(coin: 'BTC')
```

See https://www.bitget.com/api-doc/spot/intro for further information on endpoint arguments.

## Contributing

1. Fork it (https://github.com/thoran/bitget/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request


## License

MIT
