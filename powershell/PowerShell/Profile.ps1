Set-PSReadLineOption -Colors @{
  Command               = 'DarkCyan'
  Number                = 'Magenta'
  Member                = 'Blue'
  Operator              = 'Black'
  Type                  = 'Cyan'
  Variable              = 'Yellow'
  Parameter             = 'Yellow'
  ContinuationPrompt    = 'Black'
  InlinePrediction      = 'DarkGray'
  Default               = 'DarkGreen'
}

Set-PSReadLineOption -PredictionSource History
