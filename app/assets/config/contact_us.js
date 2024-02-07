const form = document.getElementById("emailForm");
console.log(form);
form.addEventListener("click", function (event) {
  event.preventDefault();
});

function sende() {
  const name = document.getElementById("name").value;
  const email = document.getElementById("email").value;
  const phoneno = document.getElementById("phoneno").value;
  const subject = document.getElementById("subject").value;
  const message = document.getElementById("message").value;
  const body =
    "Name : " +
    name +
    "<br /> Email : " +
    email +
    "<br /> Phone no : " +
    phoneno +
    "<br /> Subject : " +
    subject +
    "<br /> Message : " +
    message;

  Email.send({
    SecureToken: "fb5f3502-7961-482b-8e3d-0d96645880a0",
    Host: "smtp.elasticemail.com",
    Username: "naveenanaga18@gmail.com",
    Password: "9A97CDBBA33BD545569CA89C0F3BB21C8843",
    To: "naveenanaga18@gmail.com",
    From: "naveenanaga18@gmail.com",
    Subject: subject,
    Body: body,
  }).then(alert("Message sent successfully!"));
}
