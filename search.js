var username = "GamePlayer-8"
var website = "https://chimmie.k.vu"

var json_url = "https://codeberg.org/api/v1/users/" + username + "/repos"

function getRandomElement(arr) {
  const randomIndex = Math.floor(Math.random() * arr.length);
  return arr[randomIndex];
}

function openUrlGithub(element) {
  if (element) {
    var webpage = "https://" + website + "/" + element
    fetch(webpage)
      .then(response => {
        if (response.ok) {
          window.open(webpage, '_blank');
        } else {
          window.open("https://codeberg.org/" + username + "/" + element, '_blank');
        }
      })
      .catch(error => {
        window.open("https://codeberg.org/" + username + "/" + element, '_blank');
    });
  }
}

function searchArray(arr, word) {
  let output = [];
  for (var i=0; i < arr.length; i++) {

    if (arr[i]["name"].includes(word)) {
      output.push(arr[i]["name"]);
    }
  }
  return output;
}

function createResultMenu(arr, menu) {
  menu.innerHTML = '';

  arr.forEach(element => {
    const link = document.createElement('a');
    link.textContent = element;
    link.href = "https://" + website + "/" + element;
    menu.appendChild(link);
  });
}

fetch(json_url)
  .then(response => {
    if (!response.ok) {
      var console_text = document.getElementById('console-text');
      console_text.textContent = 'Getting list of repositories responded with non-OK error.';
      throw new Error('Network response was not ok');
    }
    return response.json(); // Parse the response body as JSON
  })
  .then(data => {
    var json_data = data;
    // You can now work with the data as a regular JavaScript object
    var console_text = document.getElementById('console-text');
    var search_menu = document.getElementById('search-content');
    var lucky_button = document.getElementById('lucky');
    var result_menu = document.getElementById('menu');

    console_text.textContent = 'Nyothing searched yet.';

    search_menu.style.display = 'inline-block';
    lucky_button.style.display = 'inline-block';

    lucky_button.addEventListener('click', function() {
      // This function will be executed when the button is clicked
      var content = getRandomElement(json_data);
      if (content.name) {
        // Open the link in a new tab or window
        openUrlGithub(content.name);
      } else {
        console.error('The .name property is missing or invalid in the JSON object.');
      }
    });

    // Add an event listener to listen for the "input" event
    search_menu.addEventListener('input', function() {
      // This function will be executed when the text in the input changes
      const enteredText = search_menu.value;
      if (enteredText !== "") {
        console_text.textContent = "Search results:";
        createResultMenu(searchArray(json_data, enteredText), result_menu);
      } else {
        console_text.textContent = "Nyothing searched.";
        result_menu.innerHTML = '';
      }
    });

  })
  .catch(error => {
    var console_text = document.getElementById('console-text');
    console_text.textContent = 'Fetching JSON has failed, check your logs!';
    console.error('Error fetching JSON:', error);
});
