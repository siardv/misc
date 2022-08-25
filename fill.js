/*
A JavaScript bookmarklet that randomly generates strings for input
fields based on their placeholders (e.g. "First Name", "Last Name",
"Email", and "Password"). Input requires clicking the input field,
upon which the randomly generated string will appear in the input 
field. To validate the input, press any key that adds or removes 
characters from the input field (e.g., white space, backspace but 
not enter). Value changes every time the input field is activated.
*/

javascript: (function() {
  function str(x) {
    x = x || Infinity;
    return Math.random().toString(36).substr(2).substr(1, x);
  }
  document.querySelectorAll('input').forEach(i=>{
    i.addEventListener('click', function() {
      if (i.placeholder === 'First name') {
        i.value = str();
      } else if (i.placeholder === 'Last name') {
        i.value = str();
      } else if (i.placeholder === 'Email') {
        i.value = str() + '@' + str(5) + '.' + str(3);
      } else if (i.placeholder === 'Password') {
        i.value = str() + '123!';
      }
    });
  });
})();
