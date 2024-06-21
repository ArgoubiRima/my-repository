import { NgModule } from "@angular/core";
import {
  BrowserModule,
  provideClientHydration,
} from "@angular/platform-browser";

import { AppRoutingModule } from "./app-routing.module";
import { AppComponent } from "./app.component";
import { LoginComponent } from "./login/login.component";
import { ListofpersonComponent } from "./listofperson/listofperson.component";
import { DeleteUserComponent } from "./delete-user/delete-user.component";
import { AddpersonComponent } from "./addperson/addperson.component";
import { AddformulaireComponent } from "./addformulaire/addformulaire.component";
import {
  HttpClientModule,
  provideHttpClient,
  withFetch,
} from "@angular/common/http";
import { FormsModule } from "@angular/forms";
import { UpdatePersonComponent } from "./update-person/update-person.component";
import { FingerprintComponent } from "./fingerprint/fingerprint.component";
import { ChangePasswordComponent } from "./change-password/change-password.component";
import { ProfilUserComponent } from "./profil-user/profil-user.component";
import { LoginFingerPrintComponent } from "./login-fingerprint/login-fingerprint.component";

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    ListofpersonComponent,
    DeleteUserComponent,
    AddpersonComponent,
    AddformulaireComponent,
    UpdatePersonComponent,
    FingerprintComponent,
    ChangePasswordComponent,
    ProfilUserComponent,
    LoginFingerPrintComponent,
  ],
  imports: [BrowserModule, AppRoutingModule, HttpClientModule, FormsModule],
  providers: [
    provideClientHydration(),
    provideHttpClient(withFetch()), // Enable fetch APIs
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
