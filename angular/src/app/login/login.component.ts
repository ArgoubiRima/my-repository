import { Component } from "@angular/core";
import { Router } from "@angular/router";

import { AuthService } from "./auth.service";

@Component({
  selector: "app-login",
  templateUrl: "./login.component.html",
  styleUrls: ["./login.component.css"],
})
export class LoginComponent {
  loginValue: string = "";
  passwordValue: string = "";
  codeValue: string = "";

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}
  ngOnInit(): void {
    const userData = localStorage.getItem("userData");
    if (userData) {
      this.router.navigate(["/listofperson"]);
    }
  }

  login(): void {
    if (this.loginValue != "" && this.passwordValue != "") {
      if (this.codeValue != "") {
        this.authService.login(this.loginValue, this.passwordValue).subscribe(
          (response) => {
            if (response) {
              localStorage.setItem("userData", JSON.stringify(response));
              {
                if (this.codeValue != "0000") {
                  this.router.navigate(["/listofperson"]);
                } else {
                  this.router.navigate(["/profil-user"]);
                }
              }
            }
          },
          (error) => {
            console.error("Login error:", error);
            alert(error.error.error);
          }
        );
      } else {
        alert("Must input code!");
      }
    } else {
      alert("Must input Credentials!");
    }
  }
}
