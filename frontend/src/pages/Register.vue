<template>
  <div class="login">
    <h1>Login</h1>
    <form @submit.prevent="login">
      <input type="text" v-model="email" placeholder="Email" required />
      <input
        type="password"
        v-model="password"
        placeholder="Password"
        required
      />
      <input
        type="password"
        v-model="repassword"
        placeholder="Re-password"
        required
      />
      <div v-if="showErrorMessage" class="error-message">
        {{ errorMessage }}
      </div>
      <button type="submit">Login</button>
    </form>
  </div>
</template>

<script>
export default {
  data () {
    return {
      email: '',
      password: '',
      repassword: '',
      showErrorMessage: false,
      errorMessage: ''
    }
  },
  methods: {
    validatePasswordMatch () {
      return this.password === this.repassword
    },
    validatePasswordCharacter () {
      const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/
      return regex.test(this.password)
    },
    getCookie (name) {
      let cookieValue = null
      if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';')
        for (let i = 0; i < cookies.length; i++) {
          const cookie = cookies[i].trim()
          // Does this cookie string begin with the name we want?
          if (cookie.substring(0, name.length + 1) === (name + '=')) {
            cookieValue = decodeURIComponent(cookie.substring(name.length + 1))
            break
          }
        }
      }
      return cookieValue
    },
    login () {
      if (!this.validatePasswordMatch()) {
        this.showErrorMessage = true
        this.errorMessage = 'Passwords do not match'
        return
      }

      if (!this.validatePasswordCharacter()) {
        this.showErrorMessage = true
        this.errorMessage = 'Password must contain at least 8 characters, 1 uppercase letter, and 1 number'
        return
      }

      const csrftoken = this.getCookie('csrftoken')

      // Make an API call to the backend to login the user
      fetch('http://localhost:8000/api-auth/login/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrftoken
        },
        body: JSON.stringify({
          email: this.email,
          password: this.password
        })
      })
        .then((response) => {
          if (response.ok) {
            // Store the token in the local storage
            localStorage.setItem(
              'token',
              response.headers.get('Authorization')
            )
            // Redirect the user to the home page
            this.$router.push('/')
          } else {
            // Display an error message
            console.error('Login failed')
          }
        })
        .catch((error) => {
          console.error('An error occurred during login:', error)
        })
    }
  }
}
</script>

<style scoped>
.login {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

h1 {
  text-align: center;
}

form {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

input[type="text"],
input[type="password"] {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  padding: 10px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
