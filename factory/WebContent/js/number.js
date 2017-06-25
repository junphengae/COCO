function discount_value(value,x){
	var b = parseFloat(x/100);
	return addCommas(addDot(value * b));
}

function discount(value,x){
	var b = parseFloat(x/100);
	var c = value - (value * b);
	return addCommas(addDot(c));
}

function discountCommas(cost,x){
	var a = removeCommas(cost);
	var b = parseFloat(x/100);
	var c = a - (a * b);
	return addCommas(addDot(c));
}

function money(nStr){
	return addCommas(addDot(nStr));
}

function addCommas(nStr){
	nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;
}

function removeCommas(nStr){
	var nc = nStr.replace(/\,/g,'');
	return nc;
}

function addDot(nStr)
{
	var i = parseFloat(nStr);
	if(isNaN(i)) { i = 0.00; }
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	i = parseInt((i + .005) * 100);
	i = i / 100;
	s = new String(i);
	if(s.indexOf('.') < 0) { s += '.00'; }
	if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
	s = minus + s;
	return s;
}

function isNumber(sText) {
	if (sText=="") return false;
	var ValidChars = "0123456789.";
	var IsNumber=true;
	var Char;
	var dotCnt = 0;

	for (i = 0; i < sText.length && IsNumber == true; i++) 
	{ 
		Char = sText.charAt(i); 
		if (Char==".") dotCnt = dotCnt +1;
		if (ValidChars.indexOf(Char) == -1 || dotCnt>1) 
		{
			IsNumber = false;
		}
	}
	return IsNumber;
}

function clear_form(ele) {

    $(ele).find(':input').each(function() {
        switch(this.type) {
            case 'password':
            case 'select-multiple':
            case 'select-one':
            case 'text':
            case 'textarea':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });

}