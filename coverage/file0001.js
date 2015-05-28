var texts = new Array();
var states = new Array();

texts['fold000001'] = '<a href="javascript:fold(\'fold000001\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 1 to line 1</i>';
states['fold000001'] = false;
texts['fold000003'] = '<a href="javascript:fold(\'fold000003\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 3 to line 7</i>';
states['fold000003'] = false;
texts['fold000009'] = '<a href="javascript:fold(\'fold000009\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 9 to line 11</i>';
states['fold000009'] = false;
texts['fold000013'] = '<a href="javascript:fold(\'fold000013\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 13 to line 13</i>';
states['fold000013'] = false;
texts['fold000015'] = '<a href="javascript:fold(\'fold000015\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 15 to line 15</i>';
states['fold000015'] = false;
texts['fold000017'] = '<a href="javascript:fold(\'fold000017\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 17 to line 120</i>';
states['fold000017'] = false;
texts['fold000122'] = '<a href="javascript:fold(\'fold000122\');"><img border="0" height="10" width="10" src="plus.png" title="unfold code"/></a><i>&nbsp;&nbsp;code folded from line 122 to line 125</i>';
states['fold000122'] = false;

function fold(id) {
  tmp = document.getElementById(id).innerHTML;
  document.getElementById(id).innerHTML = texts[id];
  texts[id] = tmp;
  states[id] = !(states[id]);
}

function unfoldAll() {
  for (key in states) {
    if (states[key]) {
      fold(key);
    }
  }
}

function foldAll() {
  for (key in states) {
    if (!(states[key])) {
      fold(key);
    }
  }
}
