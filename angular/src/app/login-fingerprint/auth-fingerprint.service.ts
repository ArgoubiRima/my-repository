import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";

@Injectable({
  providedIn: "root",
})
export class AuthFingerPrintService {
  private baseURL = "http://localhost:8080/auth";

  constructor(private http: HttpClient) {}

  login(imageFile: File): Observable<any> {
    const formData: FormData = new FormData();
    formData.append("fingerprintImage", imageFile, imageFile.name);
    return this.http.post<any>(`${this.baseURL}/login_fingerprint`, formData);
  }
}
