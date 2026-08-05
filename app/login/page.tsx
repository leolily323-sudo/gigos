'use client'
import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
      const [error, setError] = useState('')
        const router = useRouter()

          async function handleLogin(e: React.FormEvent) {
              e.preventDefault()
                  const supabase = createClient()
                      const { error } = await supabase.auth.signInWithPassword({ email, password })
                          if (error) setError(error.message)
                              else router.push('/')
                                }

                                  return (
                                      <form onSubmit={handleLogin}>
                                            <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="Email" required />
                                                  <input type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="Password" required />
                                                        {error && <p>{error}</p>}
                                                              <button type="submit">Log in</button>
                                                                  </form>
                                                                    )
                                                                    }