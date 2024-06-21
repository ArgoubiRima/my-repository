export class Person {
  id: number = 0;
  lastname: string = "";
  firstname: string = "";
  email: string = "";
  address: string = "";
  phoneNumber: string = "";
  dob: string = "";
  gender: string = "";
  fingerprintCode: string = "";
  photo: string = "";
  photo_of_the_person: string = "";
}

export interface PersonPayload {
  lastname: string;
  firstname: string;
  email: string;
  address: string;
  phoneNumber: string;
  dob: string;
  gender: string;
}

export interface AddPersonDTO {
  profile: PersonPayload;
  password: string;
}
