const currentURL = new URLSearchParams(window.location.search);
const searchParam = currentURL.get('design_name');

if (searchParam) {
    window.location.href = `http://localhost:3000/designs?design_name=${searchParam}`;
} else {
    window.location.href = 'http://localhost:3000/designs';
}