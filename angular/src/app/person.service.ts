import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { Person, AddPersonDTO } from "./person";

@Injectable({
  providedIn: "root",
})
export class PersonService {
  private baseURL = "http://localhost:8080/persons";

  constructor(private httpClient: HttpClient) {}

  getPersonsList(): Observable<Person[]> {
    return this.httpClient.get<Person[]>(`${this.baseURL}`);
  }

  createPerson(addPersonDTO: AddPersonDTO): Observable<Object> {
    return this.httpClient.post(`${this.baseURL}`, addPersonDTO);
  }
  getPersonById(id: number): Observable<Person> {
    return this.httpClient.get<Person>(`${this.baseURL}/${id}`);
  }
  updatePerson(id: number, person: Person): Observable<Person> {
    return this.httpClient.put<Person>(`${this.baseURL}/${id}`, person);
  }
  deletePerson(id: number): Observable<Person> {
    return this.httpClient.delete<Person>(`${this.baseURL}/${id}`);
  }
  updateFingerprint(
    id_person: number,
    fingerprintImage: File
  ): Observable<void> {
    const formData: FormData = new FormData();
    formData.append(
      "fingerprintImage",
      fingerprintImage,
      fingerprintImage.name
    );
    const url = `${this.baseURL}/${id_person}/fingerprint`;
    return this.httpClient.post<void>(url, formData);
  }
}
