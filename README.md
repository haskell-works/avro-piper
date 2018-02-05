# avro-piper

A Schema-registry aware avro decoding tool

### Example
This tool is intended to be used with `kafkacat` as:

```
$ kafkacat -q -b 127.0.0.1 -t data-topic -p 4 -o beginning -c 5 -D '---' | avro-decode -r http://127.0.0.1:8081 -D '---' | jq .
{
  "id": 185,
  "name": "Utah Education Network",
  "timestamp": 1473674981000
}
{
  "id": 185,
  "name": "Utah Education Network",
  "timestamp": 1473626112000
}
{
  "id": 185,
  "name": "Utah Education Network",
  "timestamp": 1473628416000
}
{
  "id": 185,
  "name": "Utah Education Network",
  "timestamp": 1473697795000
}
{
  "id": 185,
  "name": "Utah Education Network",
  "timestamp": 1473634687000
}
```

## To build (or not to build)

```
git clone git@github.com:haskell-works/avro-piper.git
cd avro-piper
stack install
```
