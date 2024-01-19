Set-PSReadLineOption -Colors @{
  Command               = 'DarkGreen'
  Number                = 'Magenta'
  Member                = 'Blue'
  Operator              = 'Black'
  Type                  = 'Cyan'
  Variable              = 'Yellow'
  Parameter             = 'Yellow'
  ContinuationPrompt    = 'Black'
  InlinePrediction      = 'DarkGray'
}

Set-PSReadLineOption -PredictionSource History
