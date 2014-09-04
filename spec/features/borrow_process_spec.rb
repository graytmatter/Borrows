require 'spec_helper'

describe "how requests should flow", job: true do

	def login(email, choice, quantity = '', pickup_month='', pickup_date='', return_month='', return_date='')
		visit '/'
		fill_in 'signup_email1', :with => email
		click_button 'signup1'
		click_button choice

		if choice == "borrow"
			fill_in 'borrow__1', :with => quantity
			select "#{Time.now.year+1}", :from => 'request_pickupdate_1i'
			select pickup_month, :from => 'request_pickupdate_2i'
			select pickup_date, :from => 'request_pickupdate_3i'
			select "#{Time.now.year+1}", :from => 'request_returndate_1i'
			select return_month, :from => 'request_returndate_2i'
			select return_date, :from => 'request_returndate_3i'
			click_button 'submit_request'
		end
	end

	def record_test(request_total, borrow_total, borrow_checking_total, borrow_connected_total, borrow_lender_declined_total, borrow_other_did_not_use_total, borrow_not_available_total)
		Request.count.should == request_total
		Borrow.count.should == borrow_total
		Borrow.where(status1: 1).count.should == borrow_checking_total
		Borrow.where(status1: 2).count.should == borrow_connected_total
		Borrow.where(status1: 21).count.should == borrow_lender_declined_total
		Borrow.where(status1: [8,9,10,11,12,13,14,15,16,17,18,19,22]).count.should == borrow_other_did_not_use_total
		Borrow.where(status1: 20).count.should == borrow_not_available_total
	end

	def email_test(total_count, subject_line='')
		ActionMailer::Base.deliveries.size == total_count
		if total_count != 0
			ActionMailer::Base.deliveries.last.subject.should include(subject_line)
		end
	end

	def manage_test(lender_email, manage_count, connected_count)
		login(lender_email, "lend")

		page.assert_selector("#manage", :count => manage_count)
		page.assert_selector("#connected", :count => connected_count)
	end

	before do 

		#RequestMailer subject snippets
		@not_found = "not find"
		@repeat_borrow = "already requested"
		@connect = "exchange"
		@same_day = "Same day"

		@newcategory = Categorylist.create(name: "Camping")
		@newcategory.itemlists.create(name: "2-Person tent", request_list: true, inventory_list: true)

		Geography.create(zipcode:94109, city:"San Francisco", county:"San Francisco")
		Geography.create(zipcode:99999, city:"Fake", county:"Fake")

		@signup_dd = Signup.create(email:"jamesdd9302@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_jdong = Signup.create(email:"jdong8@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_ana = Signup.create(email: "anavarada@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_ngo = Signup.create(email: "ngomenclature@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_dance = Signup.create(email: "dancingknives@yahoo.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_borrows = Signup.create(email: "borrowsapp@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
		@signup_outofarea = Signup.create(email: "jamesdong.photo@gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 99999, tos: true)

		@signup_dd.inventories.create(itemlist_id: 1, available: true)
		@signup_jdong.inventories.create(itemlist_id: 1, available: true)

		@todays_date = Date.today+2 #can't actually be today because this will trigger a same day email which i am not always testing for
		@futures_date = Date.today+5
	end
		
	it "should have 2 inventories and 2 signups to start" do
		Signup.count.should == 7
		Inventory.count.should == 2
	end

	describe "A) request creation" do

		before do
			# ApplicationController.stub(session[:signup_email]).and_return("anavarada@gmail.com")
			# visit '/requests/new'
			# save_and_open_page
			
			# visit '/'
			# page.driver.post new_signup_path, :signup_email => "anavarada@gmail.com"
			# visit '/requests/new'

			# visit '/requests/new'
			# RequestController.session.stub(:[]).with(:signup_email).and_return("anavarada@gmail.com")

			# ActionController::Session::AbstractStore::SessionHash.any_instance.stubs(:signup_email).returns("anavarada@gmail.com")
			# visit '/requests/new'

			login("anavarada@gmail.com", "borrow", 1, "January", "1", "January", "5")
		end

		it "should affect records" do
			# 1- request_total, 
			# 2- borrow_total, 
			# 3- borrow_checking_total, 
			# 4- borrow_connected_total, 
			# 5- borrow_lender_declined_total, 
			# 6- borrow_other_did_not_use_total
			# 7- borrow_not_available_total
			record_test(1, 2, 2, 0, 0, 0, 0)
		end

		it "should affect emails" do
			#(count, subject: blank)
			email_test(0)
		end

		it "should affect management options for lenders" do 
			#(lender_email, manage_count, connected_count)
			manage_test("jamesdd9302@yahoo.com", 1, 0)
			manage_test("jdong8@gmail.com", 1, 0)
		end

		describe "B) jamesdd9302 declines" do

			before do
				login("jamesdd9302@yahoo.com", "lend")
				click_link 'decline 1'
			end

			it "should affect records" do
				# 1- request_total, 
				# 2- borrow_total, 
				# 3- borrow_checking_total, 
				# 4- borrow_connected_total, 
				# 5- borrow_lender_declined_total, 
				# 6- borrow_other_did_not_use_total
				# 7- borrow_not_available_total
				record_test(1, 1, 1, 0, 0, 0, 0)
			end

			it "should affect emails" do
				#(total_count, subject: blank)
				email_test(0)
			end

			it "should affect management options for lenders" do 
				#(lender_email, manage_count, connected_count)
				manage_test("jamesdd9302@yahoo.com", 0, 0)
				manage_test("jdong8@gmail.com", 1, 0)
			end

			describe "C) jdong8 declines" do

				before do
					login("jdong8@gmail.com", "lend")
					click_link 'decline 2'
				end

				it "should affect Requests and Borrows" do
					# 1- request_total, 
					# 2- borrow_total, 
					# 3- borrow_checking_total, 
					# 4- borrow_connected_total, 
					# 5- borrow_lender_declined_total, 
					# 6- borrow_other_did_not_use_total
					# 7- borrow_not_available_total
					record_test(1, 1, 0, 0, 1, 0, 0)
				end

				it "should affect emails" do
					#(total_count, subject: blank)
					email_test(1, @not_found)
				end

				it "should affect management options for lenders" do 
					#(lender_email, manage_count, connected_count)
					manage_test("jamesdd9302@yahoo.com", 0, 0)
					manage_test("jdong8@gmail.com", 0, 0)
				end

				describe "D) admin reset to checking for jamesdd9302" do
					#don't create second record back, this is just a customary thing for the borrower to accept, i'd only do this when I know who's going to accept

					before do
						Borrow.update_all(status1: 1, inventory_id: 1)
					end

					it "should affect Requests and Borrows" do
						# 1- request_total, 
						# 2- borrow_total, 
						# 3- borrow_checking_total, 
						# 4- borrow_connected_total, 
						# 5- borrow_lender_declined_total, 
						# 6- borrow_other_did_not_use_total
						# 7- borrow_not_available_total
						record_test(1, 1, 1, 0, 0, 0, 0)
					end

					it "should affect emails" do
						#(total_count, subject: blank)
						email_test(1, @not_found)
					end

					it "should affect management options for lenders" do 
						#(lender_email, manage_count, connected_count)
						manage_test("jamesdd9302@yahoo.com", 1, 0)
						manage_test("jdong8@gmail.com", 0, 0)
					end

					describe "E) same dates same user test, new request" do

						before do
							login("anavarada@gmail.com", "borrow", 1, "January", "2", "January", "6")
						end

						it "should affect Requests and Borrows" do
							# 1- request_total, 
							# 2- borrow_total, 
							# 3- borrow_checking_total, 
							# 4- borrow_connected_total, 
							# 5- borrow_lender_declined_total, 
							# 6- borrow_other_did_not_use_total
							# 7- borrow_not_available_total
							record_test(2, 1, 1, 0, 0, 0, 0)
						end

						it "should affect emails" do
							#(total_count, subject: blank)
							email_test(2, @repeat_borrow)
						end

						it "should affect management options for lenders" do 
							#(lender_email, manage_count, connected_count)
							manage_test("jamesdd9302@yahoo.com", 1, 0)
							manage_test("jdong8@gmail.com", 0, 0)
						end

						describe "F) same dates diff user test (first user didn't get item), new request" do

							before do
								login("ngomenclature@gmail.com", "borrow", 1, "January", "3", "January", "6")
							end

							it "should affect Requests and Borrows" do
								# 1- request_total, 
								# 2- borrow_total, 
								# 3- borrow_checking_total, 
								# 4- borrow_connected_total, 
								# 5- borrow_lender_declined_total, 
								# 6- borrow_other_did_not_use_total
								# 7- borrow_not_available_total
								record_test(3, 3, 3, 0, 0, 0, 0)
							end

							it "should affect emails" do
								#(total_count, subject: blank)
								email_test(2, @repeat_borrow)
							end

							it "should affect management options for lenders" do 
								#(lender_email, manage_count, connected_count)
								manage_test("jamesdd9302@yahoo.com", 2, 0)
								manage_test("jdong8@gmail.com", 1, 0)
							end

							describe "G) test consequences of accept" do

								before do
									login("jamesdd9302@yahoo.com", "lend")
									click_link 'accept 2'
								end

								it "should affect Requests and Borrows" do
									# 1- request_total, 
									# 2- borrow_total, 
									# 3- borrow_checking_total, 
									# 4- borrow_connected_total, 
									# 5- borrow_lender_declined_total, 
									# 6- borrow_other_did_not_use_total
									# 7- borrow_not_available_total
									record_test(3, 2, 1, 1, 0, 0, 0)
								end

								it "should affect emails" do
									#(total_count, subject: blank)
									email_test(3, @connect)
								end

								it "should affect management options for lenders" do 
									#(lender_email, manage_count, connected_count)
									manage_test("jamesdd9302@yahoo.com", 0, 1)
									manage_test("jdong8@gmail.com", 1, 0)
								end

								describe "H) setup, accept last borrow" do

									before do
										login("jdong8@gmail.com", "lend")
										click_link 'accept 4'
									end

									it "should affect Requests and Borrows" do
										# 1- request_total, 
										# 2- borrow_total, 
										# 3- borrow_checking_total, 
										# 4- borrow_connected_total, 
										# 5- borrow_lender_declined_total, 
										# 6- borrow_other_did_not_use_total
										# 7- borrow_not_available_total
										record_test(3, 2, 0, 2, 0, 0, 0)
									end

									it "should affect emails" do
										#(total_count, subject: blank)
										email_test(4, @connect)
									end

									it "should affect management options for lenders" do 
										#(lender_email, manage_count, connected_count)
										manage_test("jamesdd9302@yahoo.com", 0, 1)
										manage_test("jdong8@gmail.com", 0, 1)
									end

									describe "I) test same dates, diff user, but first borrower did get it" do

										before do
											login("dancingknives@yahoo.com", "borrow", 1, "January", "4", "January", "5")
										end

										it "should affect Requests and Borrows" do
											# 1- request_total, 
											# 2- borrow_total, 
											# 3- borrow_checking_total, 
											# 4- borrow_connected_total, 
											# 5- borrow_lender_declined_total, 
											# 6- borrow_other_did_not_use_total
											# 7- borrow_not_available_total
											record_test(4, 3, 0, 2, 0, 0, 1)
										end

										it "should affect emails" do
											#(total_count, subject: blank)
											email_test(5, @not_found)
										end

										it "should affect management options for lenders" do 
											#(lender_email, manage_count, connected_count)
											manage_test("jamesdd9302@yahoo.com", 0, 1)
											manage_test("jdong8@gmail.com", 0, 1)
										end

										describe "J) test update connected status to did not use" do

											before do
												Borrow.first.update_attributes(status1: 8)
											end

											it "should affect Requests and Borrows" do
												# 1- request_total, 
												# 2- borrow_total, 
												# 3- borrow_checking_total, 
												# 4- borrow_connected_total, 
												# 5- borrow_lender_declined_total, 
												# 6- borrow_other_did_not_use_total
												# 7- borrow_not_available_total
												record_test(4, 3, 0, 1, 0, 1, 1)
											end

											it "should affect emails" do
												#(total_count, subject: blank)
												email_test(5, @not_found)
											end

											it "should affect management options for lenders" do 
												#(lender_email, manage_count, connected_count)
												manage_test("jamesdd9302@yahoo.com", 0, 0)
												manage_test("jdong8@gmail.com", 0, 1)
											end

											describe "K) diff dates diff user (edge date)" do

												before do
													login("borrowsapp@gmail.com", "borrow", 1, "January", "6", "January", "15")
												end

												it "should affect Requests and Borrows" do
													# 1- request_total, 
													# 2- borrow_total, 
													# 3- borrow_checking_total, 
													# 4- borrow_connected_total, 
													# 5- borrow_lender_declined_total, 
													# 6- borrow_other_did_not_use_total
													# 7- borrow_not_available_total
													record_test(5, 5, 2, 1, 0, 1, 1)
												end

												it "should affect emails" do
													#(total_count, subject: blank)
													email_test(5, @not_found)
												end

												it "should affect management options for lenders" do 
													#(lender_email, manage_count, connected_count)
													manage_test("jamesdd9302@yahoo.com", 1, 0)
													manage_test("jdong8@gmail.com", 1, 1)
												end

												describe "L) diff dates same user" do

													before do
														login("anavarada@gmail.com", "borrow", 1, "January", "14", "January", "20")
													end

													it "should affect Requests and Borrows" do
														# 1- request_total, 
														# 2- borrow_total, 
														# 3- borrow_checking_total, 
														# 4- borrow_connected_total, 
														# 5- borrow_lender_declined_total, 
														# 6- borrow_other_did_not_use_total
														# 7- borrow_not_available_total
														record_test(6, 7, 4, 1, 0, 1, 1)
													end

													it "should affect emails" do
														#(total_count, subject: blank)
														email_test(5, @not_found)
													end

													it "should affect management options for lenders" do 
														#(lender_email, manage_count, connected_count)
														manage_test("jamesdd9302@yahoo.com", 2, 0)
														manage_test("jdong8@gmail.com", 2, 1)
													end

													describe "M) more than one item requested, exactly same as supply, diff dates assumed" do

														before do
															login("dancingknives@yahoo.com", "borrow", 2, "January", "25", "January", "30")
														end

														it "should affect Requests and Borrows" do
															# 1- request_total, 
															# 2- borrow_total, 
															# 3- borrow_checking_total, 
															# 4- borrow_connected_total, 
															# 5- borrow_lender_declined_total, 
															# 6- borrow_other_did_not_use_total
															# 7- borrow_not_available_total
															record_test(7, 11, 8, 1, 0, 1, 1)
														end

														it "should affect emails" do
															#(total_count, subject: blank)
															email_test(5, @not_found)
														end

														it "should affect management options for lenders" do 
															#(lender_email, manage_count, connected_count)
															manage_test("jamesdd9302@yahoo.com", 4, 0)
															manage_test("jdong8@gmail.com", 4, 1)
														end

														describe "N) jamesdd9302 declines one of the 2 tents requested" do

															before do
																login("jamesdd9302@yahoo.com", "lend")
																click_link "decline 10"
															end

															it "should affect Requests and Borrows" do
																# 1- request_total, 
																# 2- borrow_total, 
																# 3- borrow_checking_total, 
																# 4- borrow_connected_total, 
																# 5- borrow_lender_declined_total, 
																# 6- borrow_other_did_not_use_total
																# 7- borrow_not_available_total
																record_test(7, 10, 7, 1, 0, 1, 1)
															end

															it "should affect emails" do
																#(total_count, subject: blank)
																email_test(5, @not_found)
															end

															it "should affect management options for lenders" do 
																#(lender_email, manage_count, connected_count)
																manage_test("jamesdd9302@yahoo.com", 3, 0)
																manage_test("jdong8@gmail.com", 4, 1)
															end

															describe "O) jamesdd9302 declines 2nd of the 2 tents requested" do

																before do
																	login("jamesdd9302@yahoo.com", "lend")
																	click_link "decline 12"
																end

																it "should affect Requests and Borrows" do
																	# 1- request_total, 
																	# 2- borrow_total, 
																	# 3- borrow_checking_total, 
																	# 4- borrow_connected_total, 
																	# 5- borrow_lender_declined_total, 
																	# 6- borrow_other_did_not_use_total
																	# 7- borrow_not_available_total
																	record_test(7, 9, 6, 1, 0, 1, 1)
																end

																it "should affect emails" do
																	#(total_count, subject: blank)
																	email_test(5, @not_found)
																end

																it "should affect management options for lenders" do 
																	#(lender_email, manage_count, connected_count)
																	manage_test("jamesdd9302@yahoo.com", 2, 0)
																	manage_test("jdong8@gmail.com", 4, 1)
																end

																describe "P) jdong8 also declines 2nd of the 2 tents requested" do

																	before do
																		login("jdong8@gmail.com", "lend")
																		# save_and_open_page
																		click_link "decline 13"
																	end

																	it "should affect Requests and Borrows" do
																		# 1- request_total, 
																		# 2- borrow_total, 
																		# 3- borrow_checking_total, 
																		# 4- borrow_connected_total, 
																		# 5- borrow_lender_declined_total, 
																		# 6- borrow_other_did_not_use_total
																		# 7- borrow_not_available_total
																		record_test(7, 9, 5, 1, 1, 1, 1)
																	end

																	it "should affect emails" do
																		#(total_count, subject: blank)
																		email_test(6, @not_found)
																	end

																	it "should affect management options for lenders" do 
																		#(lender_email, manage_count, connected_count)
																		manage_test("jamesdd9302@yahoo.com", 2, 0)
																		manage_test("jdong8@gmail.com", 3, 1)
																	end

																	describe "Q) request more than 1 item, exceeding supply" do

																		before do
																			login("dancingknives@yahoo.com", "borrow", 3, "February", "1", "February", "2")
																		end

																		it "should affect Requests and Borrows" do
																			# 1- request_total, 
																			# 2- borrow_total, 
																			# 3- borrow_checking_total, 
																			# 4- borrow_connected_total, 
																			# 5- borrow_lender_declined_total, 
																			# 6- borrow_other_did_not_use_total
																			# 7- borrow_not_available_total
																			record_test(8, 14, 9, 1, 1, 1, 2)
																		end

																		it "should affect emails" do
																			#(total_count, subject: blank)
																			email_test(7, @not_found)
																		end

																		it "should affect management options for lenders" do 
																			#(lender_email, manage_count, connected_count)
																			manage_test("jamesdd9302@yahoo.com", 4, 0)
																			manage_test("jdong8@gmail.com", 5, 1)
																		end

																		describe "R) jamesdd9302 declines 1 of 2 available requests" do

																			before do
																				login("jamesdd9302@yahoo.com", "lend")
																				click_link "decline 15"
																			end

																			it "should affect Requests and Borrows" do
																				# 1- request_total, 
																				# 2- borrow_total, 
																				# 3- borrow_checking_total, 
																				# 4- borrow_connected_total, 
																				# 5- borrow_lender_declined_total, 
																				# 6- borrow_other_did_not_use_total
																				# 7- borrow_not_available_total
																				record_test(8, 13, 8, 1, 1, 1, 2)
																			end

																			it "should affect emails" do
																				#(total_count, subject: blank)
																				email_test(7, @not_found)
																			end

																			it "should affect management options for lenders" do 
																				#(lender_email, manage_count, connected_count)
																				manage_test("jamesdd9302@yahoo.com", 3, 0)
																				manage_test("jdong8@gmail.com", 5, 1)
																			end

																			describe "S) jdong8 declines 1 of 2 available requests" do

																				before do
																					login("jdong8@gmail.com", "lend")
																					click_link "decline 16"
																				end

																				it "should affect Requests and Borrows" do
																					# 1- request_total, 
																					# 2- borrow_total, 
																					# 3- borrow_checking_total, 
																					# 4- borrow_connected_total, 
																					# 5- borrow_lender_declined_total, 
																					# 6- borrow_other_did_not_use_total
																					# 7- borrow_not_available_total
																					record_test(8, 13, 7, 1, 2, 1, 2)
																				end

																				it "should affect emails" do
																					#(total_count, subject: blank)
																					email_test(7, @not_found)
																				end

																				it "should affect management options for lenders" do 
																					#(lender_email, manage_count, connected_count)
																					manage_test("jamesdd9302@yahoo.com", 3, 0)
																					manage_test("jdong8@gmail.com", 4, 1)
																				end

																				describe "T) jamesdd9302 declines 2 of 2 available requests" do

																					before do
																						login("jamesdd9302@yahoo.com", "lend")
																						click_link "decline 17"
																					end

																					it "should affect Requests and Borrows" do
																						# 1- request_total, 
																						# 2- borrow_total, 
																						# 3- borrow_checking_total, 
																						# 4- borrow_connected_total, 
																						# 5- borrow_lender_declined_total, 
																						# 6- borrow_other_did_not_use_total
																						# 7- borrow_not_available_total
																						record_test(8, 12, 6, 1, 2, 1, 2)
																					end

																					it "should affect emails" do
																						#(total_count, subject: blank)
																						email_test(8, @not_found)
																					end

																					it "should affect management options for lenders" do 
																						#(lender_email, manage_count, connected_count)
																						manage_test("jamesdd9302@yahoo.com", 2, 0)
																						manage_test("jdong8@gmail.com", 4, 1)
																					end

																					describe "U) jdong declines 2 of 2 available requests" do

																						before do
																							login("jdong8@gmail.com", "lend")
																							click_link "decline 18"
																						end

																						it "should affect Requests and Borrows" do
																							# 1- request_total, 
																							# 2- borrow_total, 
																							# 3- borrow_checking_total, 
																							# 4- borrow_connected_total, 
																							# 5- borrow_lender_declined_total, 
																							# 6- borrow_other_did_not_use_total
																							# 7- borrow_not_available_total
																							record_test(8, 12, 5, 1, 3, 1, 2)
																						end

																						it "should affect emails" do
																							#(total_count, subject: blank)
																							email_test(9, @not_found)
																						end

																						it "should affect management options for lenders" do 
																							#(lender_email, manage_count, connected_count)
																							manage_test("jamesdd9302@yahoo.com", 2, 0)
																							manage_test("jdong8@gmail.com", 3, 1)
																						end

																						describe "V) same user makes a request" do

																							before do
																								login("jamesdd9302@yahoo.com", "borrow", 2, "February", "10", "February", "15")
																							end

																							it "should affect Requests and Borrows" do
																								# 1- request_total, 
																								# 2- borrow_total, 
																								# 3- borrow_checking_total, 
																								# 4- borrow_connected_total, 
																								# 5- borrow_lender_declined_total, 
																								# 6- borrow_other_did_not_use_total
																								# 7- borrow_not_available_total
																								record_test(9, 14, 6, 1, 3, 1, 3)
																							end

																							it "should affect emails" do
																								#(total_count, subject: blank)
																								email_test(10, @not_found)
																							end

																							it "should affect management options for lenders" do 
																								#(lender_email, manage_count, connected_count)
																								manage_test("jamesdd9302@yahoo.com", 2, 0)
																								manage_test("jdong8@gmail.com", 4, 1)
																							end

																								describe "X) past requests should not appear if the status was did not use PB or used but complete, but should appear if it is in progress" do

																									before do
																										past_didnotuse = Request.new(signup_id: Signup.find_by_email("anavarada@gmail.com").id, pickupdate: Date.today - 10, returndate: Date.today + 2)
																										past_didnotuse.save(:validate => false)
																										Borrow.create(itemlist_id: 1, inventory_id:1, multiple:1, status1: 8, request_id: Request.last.id)
																								
																										past_inprogress = Request.new(signup_id: Signup.find_by_email("ngomenclature@gmail.com").id, pickupdate: Date.today - 10, returndate: Date.today + 2)
																										past_inprogress.save(:validate => false)
																										Borrow.create(itemlist_id: 1, inventory_id:2, multiple:1, status1: 3, request_id: Request.last.id)
																								
																										past_complete = Request.new(signup_id: Signup.find_by_email("dancingknives@yahoo.com").id, pickupdate: Date.today - 20, returndate: Date.today - 18)
																										past_complete.save(:validate => false)
																										Borrow.create(itemlist_id: 1, inventory_id:2, multiple:1, status1: 4, request_id: Request.last.id)
																									end
																								
																									it "should affect Requests and Borrows" do
																										# 1- request_total, 
																										# 2- borrow_total, 
																										# 3- borrow_checking_total, 
																										# 4- borrow_connected_total, 
																										# 5- borrow_lender_declined_total, 
																										# 6- borrow_other_did_not_use_total
																										# 7- borrow_not_available_total
																										record_test(12, 17, 6, 1, 3, 2, 3)
																										Borrow.where(status1: 3).count.should == 1
																										Borrow.where(status1: 4).count.should == 1
																									end

																									it "should affect emails" do
																										#(total_count, subject: blank)
																										email_test(10, @not_found)
																									end

																									it "should affect management options for lenders" do 
																										#(lender_email, manage_count, connected_count)
																										manage_test("jamesdd9302@yahoo.com", 2, 0)
																										manage_test("jdong8@gmail.com", 4, 1)

																										login("jdong8@gmail.com", "lend")
																										page.assert_selector("#in_progress", :count => 1)
																									end

																									describe "Y) accept when dates don't overlap: invenotry should NOT become not available" do

																										before do
																											login("jdong8@gmail.com", "lend")
																											click_link ("accept 11")
																										end

																										it "should affect Requests and Borrows" do
																											# 1- request_total, 
																											# 2- borrow_total, 
																											# 3- borrow_checking_total, 
																											# 4- borrow_connected_total, 
																											# 5- borrow_lender_declined_total, 
																											# 6- borrow_other_did_not_use_total
																											# 7- borrow_not_available_total
																											record_test(12, 17, 5, 2, 3, 2, 3)
																											#and checking total = 2 + sum of others, due to past complete not on here 
																										end

																										it "should affect emails" do
																											#(total_count, subject: blank)
																											email_test(11, @connect)
																										end

																										it "should affect management options for lenders" do 
																											#(lender_email, manage_count, connected_count)
																											manage_test("jamesdd9302@yahoo.com", 2, 0)
																											manage_test("jdong8@gmail.com", 3, 2)
																										end

																										describe "Z) accept when dates do overlap: invenotry (requested by other lender, same has been tested to death) should become not available" do

																											before do
																												login("jamesdd9302@yahoo.com", "lend")
																												click_link ("accept 8")
																											end

																											it "should affect Requests and Borrows" do
																												# 1- request_total, 
																												# 2- borrow_total, 
																												# 3- borrow_checking_total, 
																												# 4- borrow_connected_total, 
																												# 5- borrow_lender_declined_total, 
																												# 6- borrow_other_did_not_use_total
																												# 7- borrow_not_available_total
																												record_test(12, 15, 2, 3, 3, 2, 3)
																												#and checking total = 2 + sum of others, due to past complete not on here
																											end

																											it "should affect emails" do
																												#(total_count, subject: blank)
																												email_test(12, @connect)
																											end

																											it "should affect management options for lenders" do 
																												#(lender_email, manage_count, connected_count)
																												manage_test("jamesdd9302@yahoo.com", 0, 1)
																												manage_test("jdong8@gmail.com", 2, 2)
																											end

																											describe "AA) test that when borrower requests multiple things an accept on one of them by a lender doesn't negate the fact that the other is checking for all lenders" do

																												before do
																													login("anavarada@gmail.com", "borrow", 2, "February", "12", "February", "17")
																													login("jdong8@gmail.com", "lend")
																													click_link "accept #{Borrow.last.id}"
																												end

																												it "should affect Requests and Borrows" do
																													# 1- request_total, 
																													# 2- borrow_total, 
																													# 3- borrow_checking_total, 
																													# 4- borrow_connected_total, 
																													# 5- borrow_lender_declined_total, 
																													# 6- borrow_other_did_not_use_total
																													# 7- borrow_not_available_total
																													record_test(13, 17, 2, 4, 3, 2, 4)
																													#and checking total = 2 + sum of others, due to past complete not on here
																												end

																												it "should affect emails" do
																													#not the normal pattern because two emails are sent

																													ActionMailer::Base.deliveries.size == 14

																													#second to last email
																													index = ActionMailer::Base.deliveries.length - 2
																													ActionMailer::Base.deliveries[index].subject.should include(@connect)
																													
																													#last email
																													ActionMailer::Base.deliveries.last.subject.should include(@not_found)
																												end

																												it "should affect management options for lenders" do 
																													#(lender_email, manage_count, connected_count)
																													manage_test("jamesdd9302@yahoo.com", 1, 1)
																													manage_test("jdong8@gmail.com", 1, 3)
																												end

																												describe "AB) test that when borrower requests sth, as long as one item has not been accepted where borrowers are differnet, the sth is still created, but doens't show for jdong who can't provide availability" do

																													before do
																														login("borrowsapp@gmail.com", "borrow", 2, "February", "14", "February", "18")
																													end

																													it "should affect Requests and Borrows" do
																														# 1- request_total, 
																														# 2- borrow_total, 
																														# 3- borrow_checking_total, 
																														# 4- borrow_connected_total, 
																														# 5- borrow_lender_declined_total, 
																														# 6- borrow_other_did_not_use_total
																														# 7- borrow_not_available_total
																														record_test(14, 19, 4, 4, 3, 2, 4)
																														#and checking total = 2 + sum of others, due to past complete not on here
																													end

																													it "should affect emails" do
																														#(total_count, subject: blank)
																														email_test(14, @not_found)
																													end

																													it "should affect management options for lenders" do 
																														#(lender_email, manage_count, connected_count)
																														manage_test("jamesdd9302@yahoo.com", 3, 1)
																													 manage_test("jdong8@gmail.com", 1, 3)
																													end

																													describe "AC) flip of AB, now test that the inventory in question is not being used, so should just add borrows as usual" do

																														before do
																															login("anavarada@gmail.com", "borrow", 2, Date::MONTHNAMES[(@todays_date+31).month], (@todays_date +31).day, Date::MONTHNAMES[(@todays_date +33).month], (@todays_date +33).day)
																														end

																														it "should affect Requests and Borrows" do
																															# 1- request_total, 
																															# 2- borrow_total, 
																															# 3- borrow_checking_total, 
																															# 4- borrow_connected_total, 
																															# 5- borrow_lender_declined_total, 
																															# 6- borrow_other_did_not_use_total
																															# 7- borrow_not_available_total
																															record_test(15, 23, 8, 4, 3, 2, 4)
																															#and checking total = 2 + sum of others, due to past complete not on here
																														end

																														it "should affect emails" do
																															#(total_count, subject: blank)
																															email_test(14, @not_found)
																														end

																														it "should affect management options for lenders" do 
																															#(lender_email, manage_count, connected_count)
																															manage_test("jamesdd9302@yahoo.com", 5, 1)
																													  manage_test("jdong8@gmail.com", 3, 3)
																														end
																													end
																												end
																											end
																										end
																									end
																								end
																						end
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	describe "out of area request" do

		before do
			login("jamesdong.photo@gmail.com", "borrow", 1, "April", "1", "April", "5")
		end

		it "should affect records" do
			# 1- request_total, 
			# 2- borrow_total, 
			# 3- borrow_checking_total, 
			# 4- borrow_connected_total, 
			# 5- borrow_lender_declined_total, 
			# 6- borrow_other_did_not_use_total
			# 7- borrow_not_available_total
			record_test(1, 1, 0, 0, 0, 0, 1)
		end

		it "should affect emails" do
			#(count, subject: blank)
			email_test(1, @not_found)
		end

		it "should affect management options for lenders" do 
			#(lender_email, manage_count, connected_count)
			manage_test("jamesdd9302@yahoo.com", 0, 0)
			manage_test("jdong8@gmail.com", 0, 0)
		end

	end

	describe "same day request" do

		#doesn't work but will soon be irrelevant once rentals start so don't worry about it
		before do
			login("dancingknives@yahoo.com", "borrow", 1, Date::MONTHNAMES[(Date.today).month], (Date.today).day, Date::MONTHNAMES[@futures_date.month], @futures_date.day)
		end

		it "should affect records" do
			# 1- request_total, 
			# 2- borrow_total, 
			# 3- borrow_checking_total, 
			# 4- borrow_connected_total, 
			# 5- borrow_lender_declined_total, 
			# 6- borrow_other_did_not_use_total
			# 7- borrow_not_available_total
			record_test(1, 2, 2, 0, 0, 0, 0)
		end

		it "should affect emails" do
			#(count, subject: blank)
			email_test(1, @same_day)
		end

		it "should affect management options for lenders" do 
			#(lender_email, manage_count, connected_count)
			manage_test("jamesdd9302@yahoo.com", 1, 0)
			manage_test("jdong8@gmail.com", 1, 0)
		end

	end

	describe "requesting unavailable items" do

		before do
			@newcategory.itemlists.create(name: "3-Person tent", request_list: true)
			@newcategory.itemlists.create(name: "4-Person tent", request_list: true)

			@signup_jdong.inventories.create(itemlist_id: 2, available: nil)
			@signup_jdong.inventories.create(itemlist_id: 3, available: false)
			login("jamesdong.photo@gmail.com", "borrow")
			fill_in 'borrow__2', :with => 1
			fill_in 'borrow__3', :with => 1
			select @todays_date.year, :from => 'request_pickupdate_1i'
			select Date::MONTHNAMES[@todays_date.month], :from => 'request_pickupdate_2i'
			select @todays_date.day, :from => 'request_pickupdate_3i'
			select @futures_date.year, :from => 'request_returndate_1i'
			select Date::MONTHNAMES[@futures_date.month], :from => 'request_returndate_2i'
			select @futures_date.day, :from => 'request_returndate_3i'
			click_button 'submit_request'
		end

		it "should affect records" do
			# 1- request_total, 
			# 2- borrow_total, 
			# 3- borrow_checking_total, 
			# 4- borrow_connected_total, 
			# 5- borrow_lender_declined_total, 
			# 6- borrow_other_did_not_use_total
			# 7- borrow_not_available_total
			record_test(1, 2, 0, 0, 0, 0, 2)
		end

		it "should affect emails" do
			#(count, subject: blank)
			email_test(2, @not_found)
		end

		it "should affect management options for lenders" do 
			#(lender_email, manage_count, connected_count)
			manage_test("jamesdd9302@yahoo.com", 0, 0)
			manage_test("jdong8@gmail.com", 0, 0)
		end

	end

	describe "later on lender adds an item earlier requested - setting the stage" do

		before do
			login("ngomenclature@gmail.com", "borrow", 2, "April", "1", "April", "5")
		end

		it "should affect records" do
			# 1- request_total, 
			# 2- borrow_total, 
			# 3- borrow_checking_total, 
			# 4- borrow_connected_total, 
			# 5- borrow_lender_declined_total, 
			# 6- borrow_other_did_not_use_total
			# 7- borrow_not_available_total
			record_test(1, 4, 4, 0, 0, 0, 0)
		end

		it "should affect emails" do
			#(count, subject: blank)
			email_test(0)
		end

		it "should affect management options for lenders" do 
			#(lender_email, manage_count, connected_count)
			manage_test("jamesdd9302@yahoo.com", 2, 0)
			manage_test("jdong8@gmail.com", 2, 0)
			manage_test("anavarada@gmail.com", 0, 0)
		end

		describe "- actual test same zipcode" do
			
			before do
				login("anavarada@gmail.com", "lend")
				fill_in 'inventory_1', :with => 1
				click_button 'submit_lend'
			end

			it "should affect records" do
				# 1- request_total, 
				# 2- borrow_total, 
				# 3- borrow_checking_total, 
				# 4- borrow_connected_total, 
				# 5- borrow_lender_declined_total, 
				# 6- borrow_other_did_not_use_total
				# 7- borrow_not_available_total
				record_test(1, 6, 6, 0, 0, 0, 0)
			end

			it "should affect emails" do
				#(count, subject: blank)
				email_test(0)
			end

			it "should affect management options for lenders" do 
				#(lender_email, manage_count, connected_count)
				manage_test("jamesdd9302@yahoo.com", 2, 0)
				manage_test("jdong8@gmail.com", 2, 0)
				manage_test("anavarada@gmail.com", 2, 0)
			end

			describe "- actual test diff zipcode" do
			
				before do
					login("jamesdong.photo@gmail.com", "lend")
					fill_in 'inventory_1', :with => 1
					click_button 'submit_lend'
				end

				it "should affect records" do
					# 1- request_total, 
					# 2- borrow_total, 
					# 3- borrow_checking_total, 
					# 4- borrow_connected_total, 
					# 5- borrow_lender_declined_total, 
					# 6- borrow_other_did_not_use_total
					# 7- borrow_not_available_total
					record_test(1, 6, 6, 0, 0, 0, 0)
				end

				it "should affect emails" do
					#(count, subject: blank)
					email_test(0)
				end

				it "should affect management options for lenders" do 
					#(lender_email, manage_count, connected_count)
					manage_test("jamesdd9302@yahoo.com", 2, 0)
					manage_test("jdong8@gmail.com", 2, 0)
					manage_test("anavarada@gmail.com", 2, 0)
					manage_test("jamesdong.photo@gmail.com", 0, 0)
				end

				describe "- actual test same person" do
			
					before do
						login("ngomenclature@gmail.com", "lend")
						fill_in 'inventory_1', :with => 1
						click_button 'submit_lend'
					end

					it "should affect records" do
						# 1- request_total, 
						# 2- borrow_total, 
						# 3- borrow_checking_total, 
						# 4- borrow_connected_total, 
						# 5- borrow_lender_declined_total, 
						# 6- borrow_other_did_not_use_total
						# 7- borrow_not_available_total
						record_test(1, 6, 6, 0, 0, 0, 0)
					end

					it "should affect emails" do
						#(count, subject: blank)
						email_test(0)
					end

					it "should affect management options for lenders" do 
						#(lender_email, manage_count, connected_count)
						manage_test("jamesdd9302@yahoo.com", 2, 0)
						manage_test("jdong8@gmail.com", 2, 0)
						manage_test("anavarada@gmail.com", 2, 0)
						manage_test("jamesdong.photo@gmail.com", 0, 0)
						manage_test("ngomenclature@gmail.com", 0, 0)
					end
				end
			end
		end
	end
end
