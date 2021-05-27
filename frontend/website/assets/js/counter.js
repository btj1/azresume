window.addEventListener('DOMContentLoaded', (event) => {
    getVisitorCount();
});

const apipath = 'https://visitorcountbtjaz2.azurewebsites.net/api/counterapi'
const getVisitorCount = () => {
    let currentcount = 0;

    fetch(apipath, {
        node: 'cors',
    }).then(response => {
        return response.json()
    }).then(res => {
        const currentcount = res;
        document.getElementById('counter').innerText = currentcount;
    });
    return currentcount;
}