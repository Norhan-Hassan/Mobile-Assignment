using System.ComponentModel.DataAnnotations;
namespace EnterpriseMobileApp_ASS1.DTO
{
    public class StudentRegisterDto
    {
        [Required(ErrorMessage = "Name is required")]
        public string Name { get; set; }

        public string Gender { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [RegularExpression(@"^\d+@stud\.fci-cu\.edu\.eg$", ErrorMessage = "Email format is invalid. It must be ID@stud.fci-cu.edu.eg")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Student ID is required")]
        public string StudentId { get; set; }

        [Required(ErrorMessage = "Level is required")]
        [Range(1, 4, ErrorMessage = "Level must be between 1 and 4.")]
        public int Level { get; set; }

        [Required(ErrorMessage = "Password is required")]
        [MinLength(8, ErrorMessage = "Password must be at least 8 characters long")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Confirm password is required")]
        [Compare("Password", ErrorMessage = "Passwords do not match")]
        public string ConfirmPassword { get; set; }
    }
}