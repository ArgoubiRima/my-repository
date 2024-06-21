import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ListofpersonComponent } from './listofperson.component';

describe('ListofpersonComponent', () => {
  let component: ListofpersonComponent;
  let fixture: ComponentFixture<ListofpersonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ListofpersonComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ListofpersonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
