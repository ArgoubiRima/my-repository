import { ComponentFixture, TestBed } from "@angular/core/testing";

import { LoginFingerPrintComponent } from "./login-fingerprint.component";

describe("LoginFingerPrintComponent", () => {
  let component: LoginFingerPrintComponent;
  let fixture: ComponentFixture<LoginFingerPrintComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [LoginFingerPrintComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(LoginFingerPrintComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it("should create", () => {
    expect(component).toBeTruthy();
  });
});
