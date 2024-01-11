//= link_tree ../images
//= link_directory ../stylesheets .css
//= link_tree ../../javascript .js
//= link_tree ../../../vendor/javascript .js
const currentURL = new URLSearchParams(window.location.search);
const searchParam = currentURL.get('design_name');

if (searchParam) {
    window.location.href = `http://localhost:3000/designs?design_name=${searchParam}`;
} else {
    window.location.href = 'http://localhost:3000/designs';
}



function filterDesigns(category) {
    if (category) {
      window.location.href = `http://localhost:3000/designs?category=${category}`;
    } else {
      window.location.href = 'http://localhost:3000/designs';
    }
  }
