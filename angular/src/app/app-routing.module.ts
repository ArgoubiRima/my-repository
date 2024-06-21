import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { LoginComponent } from "./login/login.component";
import { LoginFingerPrintComponent } from "./login-fingerprint/login-fingerprint.component";
import { ListofpersonComponent } from "./listofperson/listofperson.component";
import { DeleteUserComponent } from "./delete-user/delete-user.component";
import { AddpersonComponent } from "./addperson/addperson.component";
import { AddformulaireComponent } from "./addformulaire/addformulaire.component";
import { UpdatePersonComponent } from "./update-person/update-person.component";
import { ChangePasswordComponent } from "./change-password/change-password.component";
import { ProfilUserComponent } from "./profil-user/profil-user.component";

const routes: Routes = [
  { path: "login", component: LoginComponent },
  { path: "login-fingerprint", component: LoginFingerPrintComponent },
  { path: "listofperson", component: ListofpersonComponent },
  { path: "delete-user/:id", component: DeleteUserComponent },
  { path: "addperson", component: AddpersonComponent },
  { path: "addformulaire", component: AddformulaireComponent },
  { path: "update-person/:id", component: UpdatePersonComponent },
  { path: "profil-user", component: ProfilUserComponent },
  { path: "change-password", component: ChangePasswordComponent },

  { path: "", redirectTo: "/login", pathMatch: "full" },
  { path: "**", redirectTo: "/login" },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
