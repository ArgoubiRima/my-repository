import { Component, OnInit } from "@angular/core";
import { Person } from "../person";
import { PersonService } from "../person.service";
import { Router } from "@angular/router";

@Component({
  selector: "app-listofperson",
  templateUrl: "./listofperson.component.html",
  styleUrls: ["./listofperson.component.css"],
})
export class ListofpersonComponent implements OnInit {
  persons: Person[] = [];
  id: number = 0;

  constructor(
    private personService: PersonService,
    private route: Router
  ) {}
  

  ngOnInit(): void {
    this.getPersons();
  }

  private getPersons() {
    this.personService.getPersonsList().subscribe((data) => {
      this.persons = data;
    });
  }

  disconnect(): void {
    localStorage.removeItem("userData");
    this.route.navigate(["/login"]);
  }
}
