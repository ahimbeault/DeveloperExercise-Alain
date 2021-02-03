using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using PatientApp.Models;
using Microsoft.EntityFrameworkCore;

namespace PatientApp.Services
{
    public class PatientService
    {
        #region Private Variables
        private DatabaseContext _context;
        #endregion

        #region Constructor
        public PatientService(DatabaseContext context)
        {
            try
            {
                _context = context;
            }
            catch (Exception e)
            {
                Console.Write(e);
            }
        }
        #endregion

        #region Public Methods

        public bool AddPatient(Patient patient)
        {
            bool retval = false;

            if (patient != null)
            {
                patient.PatientId = Guid.NewGuid();
                _context.Add(patient);
                _context.SaveChanges();
                retval = true;
            }


            return retval;
        }

        public Patient GetPatientById(Guid patientId)
        {
            Patient retval = null;

            try
            {
                retval = _context.Patients
                    .Include(p => p.Phones)
                    .Where(p => p.PatientId == patientId)
                    .FirstOrDefault();
                    
            }
            catch(Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }

        public List<Patient> GetAllPatients(bool includeDeleted)
        {
            List<Patient> patients = null;

            try
            {
                if (includeDeleted)
                {
                    patients = _context.Patients
                        .Include(p=> p.Phones)
                        .ToList();
                }
                else
                {
                    patients = _context.Patients
                        .Include(p => p.Phones)
                        .Where(p => !p.IsDeleted)
                        .ToList();
                }

            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return patients;
        }


        public List<Patient> SearchPatients(bool includeDeleted, string search)
        {
            List<Patient> patients = null;

            try
            {
                if (includeDeleted)
                {
                    patients = _context.Patients
                        .Include(p => p.Phones)
                        .Where(p=> p.LastName.ToLower().Contains(search.ToLower()) || p.FirstName.ToLower().Contains(search.ToLower()))
                        .ToList();
                }
                else
                {
                    patients = _context.Patients
                        .Include(p => p.Phones)
                        .Where(p => !p.IsDeleted 
                        && (p.LastName.ToLower().Contains(search.ToLower()) || p.FirstName.ToLower().Contains(search.ToLower()) ))
                        .ToList();
                }

            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return patients;
        }


        public bool DeletePatient(Guid patientId)
        {
            bool retval = false;
            Patient patient;

            try
            {
                patient = _context.Patients
                    .Where(p => p.PatientId == patientId)
                    .FirstOrDefault();

                if ( patient != null)
                {
                    patient.IsDeleted = true;
                    _context.Patients.Update(patient);
                    _context.SaveChanges();

                    retval = true;
                }

            }
            catch(Exception e)
            {
                Console.WriteLine(e);
            }


            return retval;
        }

        public bool UpdatePatient(Patient patient)
        {
            bool retval = false;

            if (patient != null)
            {
                _context.Patients.Update(patient);
                _context.SaveChanges();
                retval = true;
            }

            return retval;
        }
        #endregion
    }
}
