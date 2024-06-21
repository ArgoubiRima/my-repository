import { Component, OnInit } from "@angular/core";
import { PersonService } from "../person.service";
import { Person } from "../person";
import { ActivatedRoute, Router } from "@angular/router";

@Component({
  selector: "app-update-person",
  templateUrl: "./update-person.component.html",
  styleUrls: ["./update-person.component.css"],
})
export class UpdatePersonComponent implements OnInit {
  id!: number;
  person: Person = {} as Person;

  constructor(
    private personService: PersonService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.id = this.route.snapshot.params["id"];
    this.personService.getPersonById(this.id).subscribe(
      (data: Person) => {
        this.person = data;
      },
      (error: any) => {
        console.log(error);
      }
    );
  }

  modifyPerson(): void {
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
      alert("Date of birth is invalid");
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
    this.personService.updatePerson(this.id, this.person).subscribe(
      (data: Person) => {
        
        this.router.navigate(["/listofperson"]);
      },
      (error: any) => {
        console.log(error);
        // Gérez l'erreur : affichez un message d'erreur à l'utilisateur
      }
    );
  }
}
