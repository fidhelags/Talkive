package com.example.counsellingapp.repository;

import com.example.counsellingapp.model.Booking;
import com.example.counsellingapp.model.Slot;
import com.example.counsellingapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;  
import org.springframework.data.repository.query.Param; 
import java.util.List;
import java.util.Optional;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    
    List<Booking> findByUser(User user);
    
    Optional<Booking> findBySlot(Slot slot);
    
    Optional<Booking> findByMidtransOrderId(String midtransOrderId); 

    @Query("SELECT b FROM Booking b WHERE b.slot.tutor.id = :id")
    List<Booking> findByTutorId(@Param("id") Long id);

}
