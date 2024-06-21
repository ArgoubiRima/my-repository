import { Component, OnInit } from "@angular/core";
import { PersonService } from "../person.service";
import { ActivatedRoute, Router } from "@angular/router";

@Component({
  selector: "app-delete-user",
  templateUrl: "./delete-user.component.html",
  styleUrls: ["./delete-user.component.css"],
})
export class DeleteUserComponent implements OnInit {
  id!: number;

  constructor(
    private personService: PersonService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.id = this.route.snapshot.params["id"];
  }

  confirmDelete(): void {
    this.personService.deletePerson(this.id).subscribe(
      () => {
        
        this.router.navigate(["/listofperson"]);
      },
      (error: any) => {
        console.log("Error deleting user:", error);
      }
    );
  }
}
