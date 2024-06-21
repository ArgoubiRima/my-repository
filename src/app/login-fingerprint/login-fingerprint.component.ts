import { Component } from "@angular/core";
import { Router } from "@angular/router";

import { AuthFingerPrintService } from "./auth-fingerprint.service";

@Component({
  selector: "app-login-fingerprint",
  templateUrl: "./login-fingerprint.component.html",
  styleUrls: ["./login-fingerprint.component.css"],
})
export class LoginFingerPrintComponent {
  imageFile: File | null = null;
  codeValue: string = "";

  constructor(
    private authFingerPrintService: AuthFingerPrintService,
    private router: Router
  ) {}

  ngOnInit(): void {
    const userData = localStorage.getItem("userData");
    if (userData) {
      this.router.navigate(["/listofperson"]);
    }
  }

  handleFileInput(event: any): void {
    this.imageFile = event.target.files[0];
  }

  login(): void {
    
    if (this.imageFile) {
      if (this.codeValue != "") {
        
        this.authFingerPrintService.login(this.imageFile).subscribe(
          (response) => {
            
            localStorage.setItem("userData", JSON.stringify(response));

            if (this.codeValue != "0000") {
              this.router.navigate(["/listofperson"]);
            } else {
              this.router.navigate(["/profil-user"]);
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
      alert("Please select a fingerprint image.");
    }
  }
}
