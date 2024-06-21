import { Component, OnInit } from "@angular/core";
import { ChangePWService } from "./changepw.service";
import { Router } from "@angular/router";

@Component({
  selector: "app-profil-user",
  templateUrl: "./profil-user.component.html",
  styleUrls: ["./profil-user.component.css"],
})
export class ProfilUserComponent implements OnInit {
  userData: any; // Define userData property to store user data
  newPassword: string = ""; // Property to store the new password

  constructor(
    private changePWService: ChangePWService,
    private route: Router
  ) {}

  ngOnInit(): void {
    // Retrieve user data from localStorage
    const userDataString = localStorage.getItem("userData");

    if (userDataString !== null) {
      this.userData = JSON.parse(userDataString);
    }
  }

  changePassword(): void {
    this.changePWService
      .changePW(this.userData.username, this.newPassword)
      .subscribe(
        (response) => {
          alert("Password changed successfully");
        },
        (error) => {
          
          alert("Failed to change password");
        }
      );

    // Reset the newPassword field after changing the password
    this.newPassword = "";
  }

  disconnect(): void {
    localStorage.removeItem("userData");
    this.route.navigate(["/login"]);
  }
}
