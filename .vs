{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build",
      "type": "shell",
      "command": "bash",
      "args": ["-lc", "cabal new-build && echo 'Done'"],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": {
        "owner": "haskell",
        "fileLocation": "relative",
        "pattern": [
          {
            "regexp": "^(.+?):(\\d+):(\\d+):\\s+(error|warning|info):.*$",
            "file": 1, "line": 2, "column": 3, "severity": 4
          },
          {
            "regexp": "\\s*(.*)$",
            "message": 1
          }
        ]
      },
      "presentation": {
        "echo": false,
        "reveal": "always",
        "focus": false,
        "panel": "shared",
        "showReuseMessage": false,
        "clear": true
      }
    },
    {
      "label": "Test",
      "type": "shell",
      "command": "bash",
      "args": ["-lc", "cabal new-test --enable-tests --test-show-details=direct && echo 'Done'"],
      "group": {
        "kind": "test",
        "isDefault": true
      },
      "problemMatcher": {
        "owner": "haskell",
        "fileLocation": "relative",
        "pattern": [
          {
            "regexp": "^(.+?):(\\d+):(\\d+):.*$",
            "file": 1, "line": 2, "column": 3, "severity": 4
          },
          {
            "regexp": "\\s*(\\d\\)\\s)?(.*)$",
            "message": 2
          }
        ]
      },
      "presentation": {
        "echo": false,
        "reveal": "always",
        "focus": false,
        "panel": "shared",
        "showReuseMessage": false,
        "clear": true
      }
    }
  ]
}
