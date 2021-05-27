window.addEventListener('DOMContentLoaded', (event) => {
    calc_age();
});

const calc_age = () => {
    
    var birthdate = new Date("1979/7/9");
    var cur = new Date();
    var diff = cur-birthdate; // This is the difference in milliseconds
    var age = Math.floor(diff/31557600000); // Divide by 1000*60*60*24*365.25
    print(age);
    document.getElementById('age').innerHTML = age;
    return age;
}