import { Component, OnInit } from "@angular/core";
import { PersonPayload, AddPersonDTO, Person } from "../person";
import { PersonService } from "../person.service";
import { Router } from "@angular/router";
import { log } from "console";

@Component({
  selector: "app-addformulaire",
  templateUrl: "./addformulaire.component.html",
  styleUrl: "./addformulaire.component.css",
})
export class AddformulaireComponent implements OnInit {
  person: PersonPayload = {
    lastname: "",
    firstname: "",
    email: "",
    address: "",
    phoneNumber: "",
    dob: "",
    gender: "",
  };
  password: string = "";
  confirmPassword: string = "";
  selectedImage: File | null = null;
  constructor(
    private personService: PersonService,
    private router: Router
  ) {}
  ngOnInit(): void {}

  savePerson() {
    if (!this.person.lastname) {
      alert("Last Name is required");
      return;
    }
    if (!this.person.firstname) {
      alert("First Name is required");
      return;
    }
    const pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const patternDob = /^\d{2}\/\d{2}\/\d{4}$/;
    if (!pattern.test(this.person.email)) {
      alert("Email format is Invalid");

      return;
    }
    if (!patternDob.test(this.person.dob)) {
      alert("Date of birth is Invalid");
      return;
    }
    if (!this.person.gender) {
      alert("Gender is required");
      return;
    }
    if (!this.person.phoneNumber) {
      alert("Phone Number is required");
      return;
    }
    if (!this.person.address) {
      alert("Address is required");
      return;
    }
    if (!(this.confirmPassword == this.password)) {
      alert("Passwords must match!");
      return;
    }
    const addPersonDTO: AddPersonDTO = {
      profile: this.person,
      password: this.password,
    };
    this.personService.createPerson(addPersonDTO).subscribe(
      (data: any) => {
        if (data && data.id && this.selectedImage) {
          this.personService
            .updateFingerprint(data.id, this.selectedImage)
            .subscribe(
              (response) => {
                this.goToPersonList();
              },
              (error) => alert(error.error.error)
            );
        }
      },
      (error) => console.log(error)
    );
  }
  goToPersonList() {
    this.router.navigate(["/listofperson"]);
  }
  onSubmit() {
    this.savePerson();
  }
  handleFileInput(event: any): void {
    this.selectedImage = event.target.files[0];
  }
}
