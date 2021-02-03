using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PatientApp.Models;
namespace PatientApp.Services
{
    public class PhoneService
    {
        #region Private Variables
        private DatabaseContext _context;
        #endregion

        #region Constructor

        public PhoneService (DatabaseContext context)
        {
            try
            {
                _context = context;
            }
            catch(Exception e)
            {
                Console.Write(e);
            }
        }
        #endregion

        #region Public Methods

        public bool AddPhone(Phone phone)
        {
            bool retval = false;

            if(phone != null)
            {
                phone.PhoneId = Guid.NewGuid();
                _context.Phones.Add(phone);
                _context.SaveChanges();

                retval = true;
            }


            return retval;
        }

        public List<Phone> GetPhonesByPatientId(Guid patientId)
        {
            List<Phone> retval = null;

            try
            {
                retval = _context.Phones
                    .Include(ph => ph.Patient)
                    .Where(ph => ph.Patient.PatientId == patientId)                   
                    .ToList();

            }
            catch (Exception e)
            {
                Console.Write(e);
            }


            return retval;
        }

        public bool UpdatePhone(Phone phone)
        {
            bool retval = false;


            try
            {
                if (phone != null)
                {
                    _context.Phones.Update(phone);
                    _context.SaveChanges();
                    retval = true;
                }

            }
            catch (Exception e)
            {
                Console.Write(e);
            }


            return retval;
        }

        public bool Delete(Guid phoneId)
        {
            bool retval = false;
            Phone phone;

            try
            {
                phone = _context.Phones
                    .Where(ph => ph.PhoneId == phoneId)
                    .FirstOrDefault();

                if (phone != null)
                {
                    _context.Phones.Remove(phone);
                    _context.SaveChanges();

                    retval = true;
                }

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return retval;

        }

        #endregion


    }
}
