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

        public List<Patient> GetPatients(PatientFilter filter)
        {
            List<Patient> patients = null;

            try
            {
                patients = GetPatientList(filter);
            }
            catch(Exception e)
            {
                Console.WriteLine(e);
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
        #region Private Methods
        private List<Patient> GetPatientList(PatientFilter filter)
        {
            List<Patient> patientList = null;

            try
            {
                if (filter.patientId.HasValue)
                {
                    patientList = GetPatientById(filter.patientId.Value);
                }
                else if (!string.IsNullOrEmpty(filter.search))
                {
                    patientList = SearchPatients(filter.includeDeleted, filter.search);
                }
                else
                {
                    patientList = GetAllPatients(filter.includeDeleted);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return patientList;
        }

        private List<Patient> GetPatientById(Guid patientId)
        {
            List<Patient> retval = null;

            try
            {
                retval = _context.Patients
                    .Include(p => p.Phones)
                    .Where(p => p.PatientId == patientId)
                    .ToList();

            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }

        private List<Patient> GetAllPatients(bool includeDeleted)
        {
            List<Patient> patients = null;

            try
            {
                if (includeDeleted)
                {
                    patients = _context.Patients
                        .Include(p => p.Phones)
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


        private List<Patient> SearchPatients(bool includeDeleted, string search)
        {
            List<Patient> patients = null;

            try
            {
                if (includeDeleted)
                {
                    patients = _context.Patients
                        .Include(p => p.Phones)
                        .Where(p => p.LastName.ToLower().Contains(search.ToLower()) || p.FirstName.ToLower().Contains(search.ToLower()))
                        .ToList();
                }
                else
                {
                    patients = _context.Patients
                        .Include(p => p.Phones)
                        .Where(p => !p.IsDeleted
                        && (p.LastName.ToLower().Contains(search.ToLower()) || p.FirstName.ToLower().Contains(search.ToLower())))
                        .ToList();
                }

            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return patients;
        }

        #endregion 
    }
}
