labeledInput = zb2rhhkUZFMArW5NxJJ1kseBpCMu4uCCYbcEsS1EBpFJxTMVQ
do = zb2rhkLJtRQwHz9e5GjiQkBtjL2SzZZByogr1uNZFyzJGA9dX
tokenTransfer = zb2rhnUFsd29MCBefJ5CQp4XURgnbG2HnaKzEn9wz96WBC4vN
arrayJoin = zb2rhgWm1GQM8ith9EBVJSMxsLAZBzGGsCvgnyaPZHmz3c7ym
{
  name: "wallet-sender"
  args: {token:"ETH" linkColor:"blue"}
  state: {to:"0x" amount:0}
  child: my =>
    size = (my "size")
    w = (get size "0")
    h = (get size "1")
    color = (my "linkColor")
    sendToBox = {
      name: "send-to"
      pos: [0 0]
      size: [w 64]
      onHear: to =>
        newState = {to:to amount:(my "amount")}
        (do "set" newState)>
        (do "end")
      set: {
        label: "SEND TO"
        type: "address"
        color: color
        placeholder: ""
      }
      child: labeledInput
    }
    amountBox = {
      name: "amount"
      pos: [0 96]
      size: [w 64]
      onHear: amount =>
        newState = {to:(my "to") amount:(stn amount)}
        (do "set" newState)>
        (do "stop")
      set: {
        label: "AMOUNT"
        type: "number"
        color: color
        placeholder: ""
      }
      child: labeledInput
    }
    send = {
      pos: [0 192]
      size: [w 24]
      cursor: "pointer"
      onClick:
        to = (my "to")
        amount = (my "amount")
        token = (my "token")
        result = <(tokenTransfer to amount token)
        (do "yell" result)>
        (do "stop")
      font: {weight:"bold" family:"helvetica" color:(my "linkColor")}
      child:
        amount = (my "amount")
        (arrayJoin " " ["SEND" (nts amount) (my "token")])
    }
    cancel = {
      pos: [0 236]
      size: [w 20]
      cursor: "pointer"
      font: {family:"helvetica" color:(my "linkColor")}
      onClick: | (do "yell" {type:"cancel"})> (do "stop")
      child: "Cancel"
    }
    [sendToBox amountBox send cancel]
}
