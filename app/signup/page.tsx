'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'

export default function SignUpPage() {
  const router = useRouter()
    const supabase = createClient()

      const [name, setName] = useState('')
        const [email, setEmail] = useState('')
          const [password, setPassword] = useState('')
            const [error, setError] = useState<string | null>(null)
              const [loading, setLoading] = useState(false)

                async function handleSubmit(e: React.FormEvent) {
                    e.preventDefault()
                        setError(null)
                            setLoading(true)

                                const { data: authData, error: authError } = await supabase.auth.signUp({
                                      email,
                                            password,
                                                })

                                                    if (authError) {
                                                          setError(authError.message)
                                                                setLoading(false)
                                                                      return
                                                                          }

                                                                              const userId = authData.user?.id
                                                                                  if (!userId) {
                                                                                        setError('Sign up succeeded but no user id was returned. Try logging in.')
                                                                                              setLoading(false)
                                                                                                    return
                                                                                                        }

                                                                                                            const { error: profileError } = await supabase.from('users').insert({
                                                                                                                  id: userId,
                                                                                                                        email,
                                                                                                                              display_name: name,
                                                                                                                                  })

                                                                                                                                      if (profileError) {
                                                                                                                                            setError(`Account created, but profile setup failed: ${profileError.message}`)
                                                                                                                                                  setLoading(false)
                                                                                                                                                        return
                                                                                                                                                            }

                                                                                                                                                                setLoading(false)
                                                                                                                                                                    router.push('/')
                                                                                                                                                                      }

                                                                                                                                                                        return (
                                                                                                                                                                            <div style={{ maxWidth: 400, margin: '60px auto', padding: '0 20px' }}>
                                                                                                                                                                                  <h1 style={{ fontSize: 24, fontWeight: 700, marginBottom: 8 }}>
                                                                                                                                                                                          Create your GigOS account
                                                                                                                                                                                                </h1>
                                                                                                                                                                                                      <p style={{ color: '#666', marginBottom: 24 }}>
                                                                                                                                                                                                              Find local gigs, or post one. Quick pay, no waiting weeks.
                                                                                                                                                                                                                    </p>

                                                                                                                                                                                                                          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                                                                                                                                                                                                                                  <label>
                                                                                                                                                                                                                                            Name
                                                                                                                                                                                                                                                      <input type="text" required value={name} onChange={(e) => setName(e.target.value)} style={inputStyle} />
                                                                                                                                                                                                                                                              </label>

                                                                                                                                                                                                                                                                      <label>
                                                                                                                                                                                                                                                                                Email
                                                                                                                                                                                                                                                                                          <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} style={inputStyle} />
                                                                                                                                                                                                                                                                                                  </label>

                                                                                                                                                                                                                                                                                                          <label>
                                                                                                                                                                                                                                                                                                                    Password
                                                                                                                                                                                                                                                                                                                              <input type="password" required minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} style={inputStyle} />
                                                                                                                                                                                                                                                                                                                                      </label>

                                                                                                                                                                                                                                                                                                                                              {error && <p style={{ color: 'red', fontSize: 14 }}>{error}</p>}

                                                                                                                                                                                                                                                                                                                                                      <button type="submit" disabled={loading} style={{ padding: 10, background: '#000', color: '#fff', border: 'none', borderRadius: 6 }}>
                                                                                                                                                                                                                                                                                                                                                                {loading ? 'Creating account...' : 'Sign up'}
                                                                                                                                                                                                                                                                                                                                                                        </button>
                                                                                                                                                                                                                                                                                                                                                                              </form>
                                                                                                                                                                                                                                                                                                                                                                                  </div>
                                                                                                                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                                                                                                                    }

                                                                                                                                                                                                                                                                                                                                                                                    const inputStyle: React.CSSProperties = {
                                                                                                                                                                                                                                                                                                                                                                                      display: 'block',
                                                                                                                                                                                                                                                                                                                                                                                        width: '100%',
                                                                                                                                                                                                                                                                                                                                                                                          padding: 8,
                                                                                                                                                                                                                                                                                                                                                                                            marginTop: 4,
                                                                                                                                                                                                                                                                                                                                                                                              border: '1px solid #ccc',
                                                                                                                                                                                                                                                                                                                                                                                                borderRadius: 6,
                                                                                                                                                                                                                                                                                                                                                                                                }